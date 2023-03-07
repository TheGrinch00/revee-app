import 'package:flutter/material.dart';
import 'package:revee/models/statistics.dart';
import 'package:revee/utils/theme.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsSectionWidget extends StatelessWidget {
  final String id;
  final String title;
  final List<StatisticEntry>? data;

  const StatisticsSectionWidget({
    this.id = "",
    required this.title,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          children: [
            Center(
              child: Text(title),
            ),
            Expanded(
              child: charts.BarChart(
                [
                  charts.Series<StatisticEntry, String>(
                    id: id,
                    domainFn: (StatisticEntry row, _) => row.label,
                    measureFn: (StatisticEntry row, _) => row.value,
                    colorFn: (_, __) =>
                        charts.ColorUtil.fromDartColor(CustomColors.revee),
                    data: data ?? [],
                  )
                ],
                animate: true,
                defaultRenderer: charts.BarRendererConfig(
                  cornerStrategy: const charts.ConstCornerStrategy(30),
                ),
                domainAxis: const charts.OrdinalAxisSpec(
                  renderSpec: charts.SmallTickRendererSpec(
                    minimumPaddingBetweenLabelsPx: 0,
                    labelAnchor: charts.TickLabelAnchor.centered,
                    labelStyle: charts.TextStyleSpec(
                      fontSize: 10,
                      color: charts.MaterialPalette.black,
                    ),
                    labelRotation: 60,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
