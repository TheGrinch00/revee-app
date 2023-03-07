class StatisticEntry {
  String label;
  int value;

  StatisticEntry(this.label, this.value);
}

class TimeBasedStatistics {
  List<StatisticEntry> oneMonthStats;
  List<StatisticEntry> sixMonthStats;
  List<StatisticEntry> oneYearStats;

  TimeBasedStatistics(
    this.oneMonthStats,
    this.sixMonthStats,
    this.oneYearStats,
  );

  factory TimeBasedStatistics.fromJson(Map<String, dynamic> json) {
    try {
      return TimeBasedStatistics(
        _generateEntries(json['oneMonth'] as Map<String, dynamic>? ?? {}),
        _generateEntries(json['sixMonths'] as Map<String, dynamic>? ?? {}),
        _generateEntries(json['oneYear'] as Map<String, dynamic>? ?? {}),
      );
    } catch (e) {
      return TimeBasedStatistics([], [], []);
    }
  }

  static List<StatisticEntry> _generateEntries(Map<String, dynamic> json) {
    final List<StatisticEntry> list = [];

    json.forEach((key, value) {
      list.add(StatisticEntry(key, int.parse(value.toString())));
    });

    return list;
  }

  List<StatisticEntry> getStatisticsForRange(StatisticsTimeRange range) {
    switch (range) {
      case StatisticsTimeRange.oneMonth:
        return oneMonthStats;
      case StatisticsTimeRange.sixMonths:
        return sixMonthStats;
      case StatisticsTimeRange.oneYear:
        return oneYearStats;
    }
  }
}

class BaseStatistics {
  TimeBasedStatistics visitedEmployees;
  TimeBasedStatistics newDoctors;
  TimeBasedStatistics deliveredSamples;
  List<StatisticEntry> newMedsPerCategory;
  List<StatisticEntry> newMedsPerProvince;

  BaseStatistics(
    this.visitedEmployees,
    this.newDoctors,
    this.deliveredSamples,
    this.newMedsPerCategory,
    this.newMedsPerProvince,
  );

  factory BaseStatistics.fromJson(Map<String, dynamic> json) {
    try {
      return BaseStatistics(
        TimeBasedStatistics.fromJson(
          json['visitedEmployees'] as Map<String, dynamic>? ?? {},
        ),
        TimeBasedStatistics.fromJson(
          json['newMeds'] as Map<String, dynamic>? ?? {},
        ),
        TimeBasedStatistics.fromJson(
          json['samples'] as Map<String, dynamic>? ?? {},
        ),
        (json['newMedsPerCategory'] as Map<String, dynamic>? ?? {})
            .entries
            .map((e) => StatisticEntry(e.key, int.parse(e.value.toString())))
            .toList(),
        (json['newMedsPerProvince'] as Map<String, dynamic>? ?? {})
            .entries
            .map((e) => StatisticEntry(e.key, int.parse(e.value.toString())))
            .toList(),
      );
    } catch (e) {
      return BaseStatistics(
        TimeBasedStatistics([], [], []),
        TimeBasedStatistics([], [], []),
        TimeBasedStatistics([], [], []),
        [],
        [],
      );
    }
  }
}

enum StatisticsTimeRange {
  oneMonth,
  sixMonths,
  oneYear,
}
