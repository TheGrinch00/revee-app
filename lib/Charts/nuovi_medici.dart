import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revee/models/statistics.dart';
import 'package:revee/providers/statistics_provider.dart';
import 'package:revee/widgets/charts/chart_with_range.dart';
import 'package:revee/widgets/charts/statistics_section_widget.dart';
import 'package:revee/widgets/generic/revee_loader.dart';

class NuoviMedici extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final statisticsProvider =
        Provider.of<StatisticsProvider>(context, listen: false);

    return FutureBuilder(
      future: getFutureData(statisticsProvider),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: ReveeBouncingLoader(),
          );
        }

        return Consumer<StatisticsProvider>(
          builder: (context, provider, child) {
            return ChartWithRange(
              child: (timeRange) {
                return StatisticsSectionWidget(
                  title: 'Nuovi medici',
                  data: provider.baseStatistics?.newDoctors
                      .getStatisticsForRange(timeRange),
                );
              },
            );
          },
        );
      },
    );
  }
}

Future<BaseStatistics?> getFutureData(
  StatisticsProvider statisticsProvider,
) async =>
    statisticsProvider.getBaseStats();
