import 'dart:math' as math;

/// Auto-distribution of daily dose times, as minutes after local midnight.
///
/// Times come from a fixed table, so every dose lands in waking hours
/// (07:00 to 22:00) and never at midnight. The result is only a starting
/// point: the user can edit every time by hand afterward.
abstract final class DoseScheduler {
  static const int minutesPerDay = 1440;
  static const int minDailyFrequency = 1;
  static const int maxDailyFrequency = 6;

  /// 08:00, the first dose of the day for 1 to 5 doses a day.
  static const int firstDoseMinute = 480;

  static const int defaultFrequency = 1;
  static const double defaultQuantity = 1;

  /// Gap used to place a time the user adds by hand.
  static const int addedTimeStepMinutes = 60;

  /// Dose times by number of doses a day, in minutes after midnight.
  static const Map<int, List<int>> _distribution = <int, List<int>>{
    1: <int>[480],
    2: <int>[480, 1200],
    3: <int>[480, 840, 1200],
    4: <int>[480, 720, 960, 1200],
    5: <int>[480, 660, 840, 1020, 1200],
    6: <int>[420, 600, 780, 960, 1140, 1320],
  };

  /// Returns [frequency] times (clamped to the allowed range), earliest first.
  static List<int> distribute(int frequency) {
    final int count = frequency
        .clamp(minDailyFrequency, maxDailyFrequency)
        .toInt();
    return List<int>.of(_distribution[count]!);
  }

  /// A free time for a dose the user adds by hand: [addedTimeStepMinutes]
  /// steps after the latest [taken] time, never past midnight. When nothing
  /// is free after the latest time, the first free hour from 08:00 is used.
  static int nextFreeMinute(Iterable<int> taken) {
    final Set<int> used = taken.toSet();
    if (used.isEmpty) {
      return firstDoseMinute;
    }
    final int latest = used.reduce(math.max);
    return _firstFree(used, latest + addedTimeStepMinutes) ??
        _firstFree(used, firstDoseMinute) ??
        firstDoseMinute;
  }

  /// First time not in [used], stepping from [start] until midnight, or null.
  static int? _firstFree(Set<int> used, int start) {
    for (
      int minute = start;
      minute < minutesPerDay;
      minute += addedTimeStepMinutes
    ) {
      if (!used.contains(minute)) {
        return minute;
      }
    }
    return null;
  }
}
