import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/statistics.dart';
import 'package:revee/providers/statistics_provider.dart';

import 'package:revee/Charts/chart_scaffold.dart';

/// Ritorna una [ChartScaffold] con un grafico a barre contenente il numero di contatti per fascia
/// che sono stati visitati nell'ultimo anno.
/// Le fasce sono due: la fascia A che ha una regularity di 30 giorni e la fascia B che ha una regularity di 60 giorni


class FasceAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statisticsProvider = Provider.of<StatisticsProvider>(context, listen: false);

    return ChartScaffold<List<StatisticEntry>>(
      future: _getFutureValues(statisticsProvider),
      legend: (_) => Consumer<StatisticsProvider>(
        builder: (context, provider, child) {
          return Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: provider.baseStatistics?.newMedsPerCategory.map((e) => 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.stop, color: Colors.pink),
                      Text(e.label)
                    ],
                  ),
                ),
              ).toList() ?? [],
            ),
          );
        },
      ),
      chart: (data) => Consumer<StatisticsProvider>(
        builder: (context, provider, child) {
          return BarChart(
            // ignore: unnecessary_cast
            [
              Series<_NumOfMeds, String>(
                id: 'value',
                colorFn: (_NumOfMeds value, _) => value.color,
                domainFn: (_NumOfMeds value, _) => value.fascia,
                measureFn: (_NumOfMeds value, _) => value.valore,
                data: provider.baseStatistics?.newMedsPerCategory.map(
                  (e) => _NumOfMeds(e.label, e.value, MaterialPalette.pink.shadeDefault),
                ).toList() ?? [],
              )
            ] as List<Series<dynamic, String>>,
            defaultRenderer: BarRendererConfig(
              cornerStrategy: const ConstCornerStrategy(60),
            ),
            animate: true,
          );
        },
      ),
      description:
          'Confronto del numero di contatti di fascia A con quelli di fascia B',
    );
  }
}

class _NumOfMeds {
  final String fascia;
  final int valore;
  final Color color;

  _NumOfMeds(this.fascia, this.valore, this.color);
}

Future<List<StatisticEntry>> _getFutureValues(StatisticsProvider statisticsProvider) async {
  if(statisticsProvider.baseStatistics == null) {
    await statisticsProvider.fetchBaseStatistics();
  }

  return statisticsProvider.baseStatistics?.newMedsPerCategory ?? [];
}
