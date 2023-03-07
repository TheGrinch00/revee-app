extension BetterDateTime on DateTime {
  bool isSameDay(DateTime other) {
    return day == other.day && month == other.month && year == other.year;
  }

  bool isAfterOrSameDay(DateTime other) {
    return isAfter(other) || isSameDay(other);
  }

  bool isBeforeOrSameDay(DateTime other) {
    return isBefore(other) || isSameDay(other);
  }

  bool isBetween(DateTime start, DateTime end) {
    return isAfterOrSameDay(start) && isBeforeOrSameDay(end);
  }

  DateTime startOfDay() {
    return DateTime(year, month, day);
  }

  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59, 999, 999);
  }
}
