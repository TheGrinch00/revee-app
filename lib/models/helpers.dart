import 'dart:developer' as dev;

///Convert [date] from string to DateTime
DateTime? dateFromUTC(String date) {
  DateTime t;
  try {
    t = DateTime.parse(date);
  } catch (e) {
    dev.log('invalid date: $date');
    return null;
  }
  return t;
}
