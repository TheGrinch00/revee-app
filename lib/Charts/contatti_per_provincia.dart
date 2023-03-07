import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/statistics.dart';
import 'package:revee/providers/statistics_provider.dart';

import 'package:revee/Charts/chart_scaffold.dart';

/// Ritorna una [ChartScaffold] con un [BarChart] contenente il numero di contatti per provincia
/// che sono stati visitati nell'ultimo anno.
///Con meno di 5 provincie il grafico è statico, da 6 provincie in poi si trasforma in una [ListView] che scrolla in verticale.
/// Tutte le Provincie collegate all'agente sono mostrate, a quelle che non contengono alcun cliente visitato viene assegnato il valore 0.
class ContattiProvincia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statisticsProvider =
        Provider.of<StatisticsProvider>(context, listen: false);

    return ChartScaffold<List<StatisticEntry>>(
      future: _getFutureValues(statisticsProvider),
      legend: (data) => Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Province:',
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
      chart: (data) {
        final chart = charts.BarChart(
          // ignore: unnecessary_cast
          [
            charts.Series<StatisticEntry, String>(
              id: 'value',
              colorFn: (_, __) => charts.MaterialPalette.black,
              domainFn: (StatisticEntry p, _) => p.label,
              measureFn: (StatisticEntry p, _) => p.value,
              data: data ?? [],
              fillColorFn: (_, __) => charts.MaterialPalette.gray.shade800,
              fillPatternFn: (_, __) => charts.FillPatternType.forwardHatch,
            ),
          ] as List<charts.Series<StatisticEntry, String>>,
          animate: true,
          defaultRenderer: charts.BarRendererConfig(
            cornerStrategy: const charts.ConstCornerStrategy(30),
          ),
          vertical: false,
        );
        return (data?.length ?? 0) < 6
            ? chart
            : SingleChildScrollView(
                child: SizedBox(
                  height: (data?.length ?? 0) * 80.0,
                  child: chart,
                ),
              );
      },
      description: 'Numero di contatti attivi per provincia',
    );
  }
}

Future<List<StatisticEntry>> _getFutureValues(
  StatisticsProvider statisticsProvider,
) async {
  final stats = await statisticsProvider.getBaseStats();
  return stats?.newMedsPerProvince ?? [];
}
