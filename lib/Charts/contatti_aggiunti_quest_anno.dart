import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/providers/statistics_provider.dart';
import 'package:collection/collection.dart';
import 'package:revee/Charts/chart_scaffold.dart';

/// Ritorna una [ChartScaffold] con un [BarChart] che indica i contatti aggiunti dall'agente durante quest'anno con
/// un target di 220.

class ContattiAggiuntiQuestAnno extends StatelessWidget {
  final int _target = 220;

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
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (data ?? 0) >= _target
                      ? "Hai raggiunto l'obiettivo!"
                      : "Ancora ${_target - (data ?? 0)} contatti per raggiungere l'obiettivo",
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 15,
                    color: (data ?? 0) >= _target
                        ? Colors.green.shade900
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      chart: (data) => charts.BarChart(
        [
          charts.Series<_DocsCount, String>(
            id: 'Visitati',
            domainFn: (_DocsCount sales, _) => sales.chartGroup,
            measureFn: (_DocsCount sales, _) => sales.value,
            data: [
              _DocsCount('Inseriti', data ?? 0),
            ],
            colorFn: (_, __) => charts.MaterialPalette.pink.shadeDefault,
          ),
          charts.Series<_DocsCount, String>(
            id: 'Visitati Target Line',
            domainFn: (_DocsCount sales, _) => sales.chartGroup,
            measureFn: (_DocsCount sales, _) => sales.value,
            data: [
              _DocsCount('Inseriti', _target),
            ],
            colorFn: (_, __) => charts.MaterialPalette.black,
          )
            // Configure our custom bar target renderer for this series.
            ..setAttribute(
              charts.rendererIdKey,
              'customTargetLine',
            )
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
      description: "Numero di contatti inseriti quest'anno.\nObiettivo: 220",
    );
  }
}

/// Sample ordinal data type.
class _DocsCount {
  final String chartGroup;
  final int value;

  _DocsCount(this.chartGroup, this.value);
}

Future<int> _getFutureValues(StatisticsProvider statisticsProvider) async {
  final stats = await statisticsProvider.getBaseStats();
  return stats?.visitedEmployees.oneYearStats.map((e) => e.value).sum ?? 0;
}
