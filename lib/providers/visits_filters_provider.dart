import 'package:flutter/foundation.dart';
import 'package:revee/utils/extensions/date_time_extension.dart';

enum FilterTypes {
  NONE,
  TODAY,
  THIS_WEEK,
  CUSTOM,
}

class VisitsFiltersProvider with ChangeNotifier {
  FilterTypes _filterType = FilterTypes.NONE;
  DateTime? _startDate;
  DateTime? _endDate;

  bool didFiltersChange = false;

  FilterTypes get filterType => _filterType;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  DateTime get minDate {
    return DateTime.now().subtract(const Duration(days: 365 * 10));
  }

  DateTime get maxDate {
    return DateTime.now();
  }

  DateTime get defaultStartDate {
    if (_startDate != null) return _startDate!;

    if (_endDate != null) {
      final oneWeekEarlier = _endDate!.subtract(const Duration(days: 7));
      return oneWeekEarlier.isBefore(minDate) ? minDate : oneWeekEarlier;
    }
    return DateTime.now();
  }

  DateTime get defaultEndDate {
    if (_endDate != null) return _endDate!;

    if (_startDate != null) {
      final oneWeekLater = _startDate!.add(const Duration(days: 7));
      return oneWeekLater.isAfter(maxDate) ? maxDate : oneWeekLater;
    }

    return DateTime.now();
  }

  Map<String, dynamic> get jsonWhereFilters {
    switch (filterType) {
      case FilterTypes.NONE:
        return {};
      case FilterTypes.TODAY:
        return {
          "where": {
            "and": [
              {
                "RealDate": {
                  "gte": DateTime.now().startOfDay().toIso8601String()
                },
              },
              {
                "RealDate": {
                  "lte": DateTime.now().endOfDay().toIso8601String()
                },
              },
            ],
          },
        };
      case FilterTypes.THIS_WEEK:
        return {
          "where": {
            "and": [
              {
                "RealDate": {
                  "gte": DateTime.now()
                      .subtract(const Duration(days: 7))
                      .startOfDay()
                      .toIso8601String()
                },
              },
              {
                "RealDate": {
                  "lte": DateTime.now().endOfDay().toIso8601String()
                },
              },
            ],
          },
        };
      case FilterTypes.CUSTOM:
        if (startDate != null && endDate == null) {
          return {
            "where": {
              "RealDate": {
                "gte": startDate!.startOfDay().toIso8601String(),
              }
            },
          };
        } else if (startDate == null && endDate != null) {
          return {
            "where": {
              "RealDate": {
                "lte": endDate!.endOfDay().toIso8601String(),
              },
            },
          };
        } else if (startDate != null && endDate != null) {
          return {
            "where": {
              "and": [
                {
                  "RealDate": {
                    "gte": startDate!.startOfDay().toIso8601String()
                  },
                },
                {
                  "RealDate": {"lte": endDate!.endOfDay().toIso8601String()},
                },
              ],
            },
          };
        } else {
          return {};
        }
    }
  }

  set filterType(FilterTypes filterType) {
    _filterType = filterType;
    didFiltersChange = true;
    notifyListeners();
  }

  set startDate(DateTime? startDate) {
    _startDate = startDate;
    didFiltersChange = true;
    notifyListeners();
  }

  set endDate(DateTime? endDate) {
    _endDate = endDate;
    didFiltersChange = true;
    notifyListeners();
  }
}
