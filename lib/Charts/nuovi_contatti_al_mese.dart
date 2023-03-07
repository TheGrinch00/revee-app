import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/doctor_provider.dart';
import 'package:collection/collection.dart';

import 'package:revee/Charts/chart_scaffold.dart';

class NuoviContattiMese extends StatelessWidget {
  String getMonthYearLabel(int offset) =>
      "${_getMonth(offset)}/${_getYear(offset)}";

  @override
  Widget build(BuildContext context) {
    final doctorsProvider = Provider.of<DoctorProvider>(context, listen: false);
    return ChartScaffold<List<int>>(
      future: _getFutureValues2(doctorsProvider),
      legend: (data) => Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.stop,
                    color: Colors.grey.shade700,
                  ),
                  const Text("Al mese")
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: const [
                  Icon(
                    Icons.stop,
                    color: Colors.pink,
                  ),
                  Text("Totali")
                ],
              ),
            ),
          ],
        ),
      ),
      chart: (data) => OrdinalComboChart(
        // ignore: unnecessary_cast
        [
          Series<_DocsPerMonth, String>(
            id: 'Mensile',
            colorFn: (_, __) => MaterialPalette.gray.shade700,
            domainFn: (_DocsPerMonth sales, _) => sales.month,
            measureFn: (_DocsPerMonth sales, _) => sales.value,
            data: (() {
              final List<_DocsPerMonth> list = [];

              for (var i = 0; i < 12; i++) {
                final offset = 11 - i;

                list.add(
                  _DocsPerMonth(
                    getMonthYearLabel(offset),
                    data![i],
                  ),
                );
              }
              return list;
            })(),
            fillPatternFn: (_, __) => FillPatternType.forwardHatch,
          ),
          Series<_DocsPerMonth, String>(
            id: 'Totale ',
            colorFn: (_, __) => MaterialPalette.pink.shadeDefault,
            domainFn: (_DocsPerMonth sales, _) => sales.month,
            measureFn: (_DocsPerMonth sales, _) => sales.value,
            data: (() {
              final List<_DocsPerMonth> list = [];

              for (var i = 0; i < 12; i++) {
                final offset = 11 - i;

                list.add(
                  _DocsPerMonth(
                    getMonthYearLabel(offset),
                    _getTotalData(i, data!),
                  ),
                );
              }
              return list;
            })(),
          )..setAttribute(rendererIdKey, 'customLine'),
        ] as List<Series<_DocsPerMonth, String>>,
        defaultRenderer:
            BarRendererConfig(groupingType: BarGroupingType.grouped),
        animate: true,
        customSeriesRenderers: [
          LineRendererConfig(customRendererId: 'customLine')
        ],
        domainAxis: const OrdinalAxisSpec(
          renderSpec: SmallTickRendererSpec(
            labelStyle: TextStyleSpec(fontSize: 8),
          ),
        ),
      ),
      description:
          'Confronto fra il numero di nuovi contatti inseriti negli ultimi 12 mesi',
    );
  }
}

class _DocsPerMonth {
  final String month;
  final int value;

  _DocsPerMonth(this.month, this.value);
}

Future<List<int>> _getFutureValues2(DoctorProvider doctorsProvider) async {
  final List<int> months = List.filled(12, 0);
  final DateTime limit = DateTime.now().month != 12
      ? DateTime(DateTime.now().year - 1, DateTime.now().month + 1)
      : (DateTime(DateTime.now().year));

  if (doctorsProvider.doctors.isEmpty) {
    await doctorsProvider.fetchDoctors();
  }

  for (final doctor in doctorsProvider.doctors) {
    // For null safety reasons and linting
    final firstVisit = doctor.firstVisit;

    if (firstVisit != null && firstVisit.isAfter(limit)) {
      final index = (firstVisit.month - DateTime.now().month - 1) % 12;
      months[index]++;
    }
  }

  return months;
}

/// Ritorna una [String] con le ultime due cifre dell'anno esatto di riferimento
String _getYear(int difference) {
  final int currentMonth = DateTime.now().month;
  final yearOffset = currentMonth - difference <= 0 ? 1 : 0;
  return (DateTime.now().year - yearOffset).toString().substring(2);
}

/// Ritorna il mese esatto di riferimento
String _getMonth(int difference) {
  // 0-11
  final int currentMonth = DateTime.now().month - 1;

  // 1-12 with wrap around
  final offsetMonth = (currentMonth - difference + 12) % 12 + 1;
  return offsetMonth.toString().padLeft(2, '0');
}

int _getTotalData(int count, List<int> data) => data.sublist(0, count + 1).sum;
