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
}
