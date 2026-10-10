/// Auto-distribution of daily dose times, as minutes after local midnight.
///
/// Doses are spread evenly over the full 24 hours starting at
/// [firstDoseMinute], so 2 times a day gives 08:00 and 20:00. The result is
/// only a starting point: the user can edit every time by hand afterward.
abstract final class DoseScheduler {
  static const int minutesPerDay = 1440;
  static const int minDailyFrequency = 1;
  static const int maxDailyFrequency = 6;

  /// 08:00, the first dose of the day when times are auto-distributed.
  static const int firstDoseMinute = 480;

  static const int defaultFrequency = 1;
  static const double defaultQuantity = 1;

  /// Gap used to place a time the user adds by hand.
  static const int addedTimeStepMinutes = 60;

  /// Returns [frequency] times (clamped to the allowed range), earliest first.
  static List<int> distribute(int frequency) {
    final int count = frequency
        .clamp(minDailyFrequency, maxDailyFrequency)
        .toInt();
    final int step = minutesPerDay ~/ count;
    final List<int> minutes = <int>[
      for (int index = 0; index < count; index++)
        (firstDoseMinute + index * step) % minutesPerDay,
    ]..sort();
    return minutes;
  }

  /// A free time for a dose the user adds by hand: [addedTimeStepMinutes]
  /// steps after the latest [taken] time, skipping any time already used.
  static int nextFreeMinute(Iterable<int> taken) {
    final Set<int> used = taken.toSet();
    if (used.isEmpty) {
      return firstDoseMinute;
    }
    final int latest = used.reduce((int a, int b) => a > b ? a : b);
    for (
      int offset = addedTimeStepMinutes;
      offset <= minutesPerDay;
      offset += addedTimeStepMinutes
    ) {
      final int candidate = (latest + offset) % minutesPerDay;
      if (!used.contains(candidate)) {
        return candidate;
      }
    }
    return firstDoseMinute;
  }
}
