extension CarrotDateTimeExtension on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) =>
      DateTime(
        year ?? this.year,
        month ?? this.month,
        day ?? this.day,
        hour ?? this.hour,
        minute ?? this.minute,
        second ?? this.second,
        millisecond ?? this.millisecond,
        microsecond ?? this.microsecond,
      );

  DateTime endOfDay() => copyWith(
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 999,
        microsecond: 0,
      );

  DateTime endOfMonth() => copyWith(
        month: month + 1,
        day: 0,
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 999,
        microsecond: 0,
      );

  DateTime middleOfDay() => copyWith(
        hour: 12,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  DateTime startOfDay() => copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  DateTime startOfMonth() => copyWith(
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
}

/// Gets all the dates within the given [date]'s month. When
/// [datePickerMode] is set to `true` the range will be padded
/// in a way that is usable for date pickers.
Iterable<DateTime> getMonthDates(DateTime date, {bool datePickerMode = false}) {
  final List<DateTime> dates = [];
  final end = date.endOfMonth().middleOfDay();
  final start = date.startOfMonth().middleOfDay();
  var current = start.copyWith();

  if (datePickerMode) {
    for (int i = start.weekday - 1; i >= 1; --i) {
      dates.add(start.subtract(Duration(days: i)));
    }
  }

  do {
    dates.add(current);
    current = current.add(const Duration(days: 1)).middleOfDay();
  } while (current.isBefore(end) || current == end);

  if (datePickerMode) {
    for (int i = end.weekday + 1; end.weekday != 7 && i <= 7; ++i) {
      dates.add(end.add(Duration(days: i - end.weekday)));
    }

    while ((dates.length / 7).round() < 6) {
      final last = dates.last;

      for (int i = 1; i <= 7; ++i) {
        dates.add(last.add(Duration(days: i)));
      }
    }
  }

  return dates.toList(growable: false);
}
