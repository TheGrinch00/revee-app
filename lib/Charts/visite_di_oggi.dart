import 'dart:core';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/statistics_provider.dart';

import 'package:revee/Charts/chart_scaffold.dart';

/// Ritorna una [ChartScaffold] con un [BarChart] che indica le visite fatte dall'agente durante la giornata di oggi
/// con un obiettivo di 8 visite.
class VisiteDiOggi extends StatelessWidget {
  final int _target = 8;

  @override
  Widget build(BuildContext context) {
    final statisticsProvider =
        Provider.of<StatisticsProvider>(context, listen: false);

    return ChartScaffold<int>(
      future: _getFutureValues(statisticsProvider),
      legend: (data) => Card(
        color: (data ?? 0) >= _target ? Colors.green.shade300 : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  (data ?? 0) >= _target
                      ? "Hai raggiunto l'obiettivo!"
                      : "Ancora ${_target - (data ?? 0)} visite necessarie per raggiungere l'obiettivo",
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 13,
                    color: (data ?? 0) >= _target
                        ? Colors.green.shade900
                        : Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      chart: (data) => charts.BarChart(
        // ignore: unnecessary_cast
        [
          charts.Series<_BarComponent, String>(
            id: 'Visitati',
            domainFn: (segment, _) => segment.name,
            measureFn: (segment, _) => segment.value,
            data: [_BarComponent('Visitati', data ?? 0)],
            colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
          ),
          charts.Series<_BarComponent, String>(
            id: 'Visitati Target Line',
            domainFn: (_BarComponent sales, _) => sales.name,
            measureFn: (_BarComponent sales, _) => sales.value,
            data: [_BarComponent('Visitati', _target)],
            colorFn: (_, __) => charts.MaterialPalette.black,
          )
            // Configure our custom bar target renderer for this series.
            ..setAttribute(
              charts.rendererIdKey,
              'customTargetLine',
            ),
        ],
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        customSeriesRenderers: [
          charts.BarTargetLineRendererConfig<String>(
            // ID used to link series to this renderer.
            customRendererId: 'customTargetLine',
          )
        ],
      ),
      description:
          'Numero di contatti visitati oggi.\nObiettivo: più di 8 contatti',
    );
  }
}

/// Sample data type.
class _BarComponent {
  final String name;
  final int value;

  _BarComponent(this.name, this.value);
}

Future<int> _getFutureValues(StatisticsProvider statisticsProvider) async {
  final dateFormat = DateFormat('dd/MM/yyyy');
  final currentDate = dateFormat.format(DateTime.now());

  if (statisticsProvider.baseStatistics == null) {
    await statisticsProvider.fetchBaseStatistics();
  }

  try {
    return statisticsProvider.baseStatistics?.visitedEmployees.oneMonthStats
            .where((element) => element.label == currentDate)
            .first
            .value ??
        0;
  } catch (e) {
    return 0;
  }
}
