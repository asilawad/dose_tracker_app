import 'dart:math' as math;

import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/utils/dose_scheduler.dart';
import 'package:get/get.dart';

/// The list of dose times being edited on the medication form.
///
/// The list is always sorted, earliest first, with one to six times. A time
/// (or quantity) the user edited by hand is "pinned": no automatic change
/// ever moves or removes it. While nothing is pinned, adding or removing a
/// time uses the fixed distribution table of [DoseScheduler]. Once something
/// is pinned, a new time goes into the middle of the largest gap and removing
/// one drops the latest unpinned time. Editing a time moves the later
/// unpinned times by the same amount, so the rest of the day follows it; if
/// that would leave the day or hit another time, only the edited time moves.
class DoseTimesEditor {
  DoseTimesEditor() {
    _applyTable(DoseScheduler.defaultFrequency);
  }

  static const int _lastMinute = DoseScheduler.minutesPerDay - 1;
  static const int _windowStart = 420;
  static const int _windowEnd = 1320;
  static const int _roundTo = 5;
  static const int _minGap = 10;
  static const int _hourStep = 60;

  final RxList<DoseTimeInput> times = <DoseTimeInput>[].obs;
  final Set<int> _pinned = <int>{};

  int get frequency => times.length;

  bool get canIncrease => times.length < DoseScheduler.maxDailyFrequency;

  bool get canDecrease => times.length > DoseScheduler.minDailyFrequency;

  /// Adds one time (see the class doc for where it goes).
  void increase() {
    if (!canIncrease) {
      return;
    }
    if (_pinned.isEmpty) {
      _applyTable(frequency + 1);
    } else {
      _insertInLargestGap();
    }
  }

  /// Removes one time: by the table while nothing is pinned, otherwise the
  /// latest unpinned time (the last time when every time is pinned).
  void decrease() {
    if (!canDecrease) {
      return;
    }
    if (_pinned.isEmpty) {
      _applyTable(frequency - 1);
      return;
    }
    final List<DoseTimeInput> unpinned = times
        .where((DoseTimeInput time) => !_pinned.contains(time.minuteOfDay))
        .toList();
    final DoseTimeInput target = unpinned.isNotEmpty
        ? unpinned.last
        : times.last;
    times.remove(target);
    _pinned.remove(target.minuteOfDay);
  }

  void addTime() => increase();

  /// Removes the time at [index] on purpose; the remaining times are pinned.
  void removeTime(int index) {
    if (!canDecrease || index < 0 || index >= times.length) {
      return;
    }
    times.removeAt(index);
    _pinAll();
  }

  /// Loads saved times (edit mode). They are all pinned.
  void setTimes(List<DoseTimeInput> newTimes) {
    if (newTimes.isEmpty) {
      _applyTable(DoseScheduler.defaultFrequency);
      return;
    }
    times.assignAll(_sorted(newTimes));
    _pinAll();
  }

  /// Changes one time. Returns false, and changes nothing, when the index or
  /// the minute is invalid or another time already uses the same minute.
  bool updateTime({
    required int index,
    required int minuteOfDay,
    required double quantity,
  }) {
    if (index < 0 || index >= times.length) {
      return false;
    }
    if (minuteOfDay < 0 || minuteOfDay > _lastMinute) {
      return false;
    }
    for (int other = 0; other < times.length; other++) {
      if (other != index && times[other].minuteOfDay == minuteOfDay) {
        return false;
      }
    }
    final DoseTimeInput old = times[index];
    if (old.minuteOfDay == minuteOfDay && old.quantity == quantity) {
      return true;
    }
    final List<DoseTimeInput> next = times.toList();
    next[index] = (minuteOfDay: minuteOfDay, quantity: quantity);
    final int delta = minuteOfDay - old.minuteOfDay;
    final List<DoseTimeInput> result = delta == 0
        ? next
        : _rippled(next, index, delta) ?? next;
    _pinned
      ..remove(old.minuteOfDay)
      ..add(minuteOfDay);
    times.assignAll(_sorted(result));
    return true;
  }

  /// Moves every later unpinned time by [delta]; null when that would leave
  /// the day or create a duplicate minute.
  List<DoseTimeInput>? _rippled(
    List<DoseTimeInput> next,
    int index,
    int delta,
  ) {
    final List<DoseTimeInput> result = next.toList();
    for (int i = index + 1; i < result.length; i++) {
      final DoseTimeInput time = result[i];
      if (_pinned.contains(time.minuteOfDay)) {
        continue;
      }
      final int moved = time.minuteOfDay + delta;
      if (moved < 0 || moved > _lastMinute) {
        return null;
      }
      result[i] = (minuteOfDay: moved, quantity: time.quantity);
    }
    final Set<int> unique = result
        .map((DoseTimeInput time) => time.minuteOfDay)
        .toSet();
    return unique.length == result.length ? result : null;
  }

  void _insertInLargestGap() {
    final List<int> minutes = times
        .map((DoseTimeInput time) => time.minuteOfDay)
        .toList();
    final int low = math.min(_windowStart, minutes.first);
    final int high = math.max(_windowEnd, minutes.last);
    int gapStart = low;
    int gapEnd = minutes.first;
    for (int i = 0; i < minutes.length; i++) {
      final int start = minutes[i];
      final int end = i + 1 < minutes.length ? minutes[i + 1] : high;
      if (end - start > gapEnd - gapStart) {
        gapStart = start;
        gapEnd = end;
      }
    }
    int minute = ((gapStart + gapEnd) ~/ 2 / _roundTo).round() * _roundTo;
    final bool usable =
        gapEnd - gapStart >= _minGap &&
        !minutes.contains(minute) &&
        minute >= 0 &&
        minute <= _lastMinute;
    if (!usable) {
      minute = _firstFreeMinute(minutes);
    }
    times.add((
      minuteOfDay: minute,
      quantity: DoseScheduler.defaultQuantity,
    ));
    times.assignAll(_sorted(times.toList()));
  }

  int _firstFreeMinute(List<int> taken) {
    for (
      int minute = DoseScheduler.firstDoseMinute;
      minute <= _lastMinute;
      minute += _hourStep
    ) {
      if (!taken.contains(minute)) {
        return minute;
      }
    }
    for (int minute = 0; minute <= _lastMinute; minute++) {
      if (!taken.contains(minute)) {
        return minute;
      }
    }
    return DoseScheduler.firstDoseMinute;
  }

  void _applyTable(int count) {
    _pinned.clear();
    times.assignAll(
      DoseScheduler.distribute(count).map(
        (int minute) =>
            (minuteOfDay: minute, quantity: DoseScheduler.defaultQuantity),
      ),
    );
  }

  void _pinAll() {
    _pinned
      ..clear()
      ..addAll(times.map((DoseTimeInput time) => time.minuteOfDay));
  }

  static List<DoseTimeInput> _sorted(List<DoseTimeInput> source) {
    return source.toList()..sort(
      (DoseTimeInput a, DoseTimeInput b) =>
          a.minuteOfDay.compareTo(b.minuteOfDay),
    );
  }
}
