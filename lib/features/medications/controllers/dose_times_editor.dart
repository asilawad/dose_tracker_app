import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/utils/dose_scheduler.dart';
import 'package:get/get.dart';

/// The list of dose times being edited on Add Medication.
///
/// The number of times is always the length of [times]. [increase] and
/// [decrease] redistribute the times evenly over the waking hours (which
/// discards manual edits), while adding, removing or editing one time keeps
/// the others as they are. The list is always sorted, earliest first, and
/// holds between one and six times.
class DoseTimesEditor {
  DoseTimesEditor() {
    _distribute(DoseScheduler.defaultFrequency);
  }

  final RxList<DoseTimeInput> times = <DoseTimeInput>[].obs;

  int get frequency => times.length;

  bool get canIncrease => times.length < DoseScheduler.maxDailyFrequency;

  bool get canDecrease => times.length > DoseScheduler.minDailyFrequency;

  void increase() {
    if (canIncrease) {
      _distribute(frequency + 1);
    }
  }

  void decrease() {
    if (canDecrease) {
      _distribute(frequency - 1);
    }
  }

  /// Adds one time after the latest one, keeping the other times as they are.
  void addTime() {
    if (!canIncrease) {
      return;
    }
    times.add((
      minuteOfDay: DoseScheduler.nextFreeMinute(
        times.map((DoseTimeInput time) => time.minuteOfDay),
      ),
      quantity: DoseScheduler.defaultQuantity,
    ));
    _sort();
  }

  void removeTime(int index) {
    if (!canDecrease || index < 0 || index >= times.length) {
      return;
    }
    times.removeAt(index);
  }

  /// Changes one time. Returns false, and changes nothing, when another time
  /// already uses the same minute or the index is invalid.
  bool updateTime({
    required int index,
    required int minuteOfDay,
    required double quantity,
  }) {
    if (index < 0 || index >= times.length) {
      return false;
    }
    for (int other = 0; other < times.length; other++) {
      if (other != index && times[other].minuteOfDay == minuteOfDay) {
        return false;
      }
    }
    times[index] = (minuteOfDay: minuteOfDay, quantity: quantity);
    _sort();
    return true;
  }

  void _distribute(int count) {
    times.assignAll(
      DoseScheduler.distribute(count).map(
        (int minute) =>
            (minuteOfDay: minute, quantity: DoseScheduler.defaultQuantity),
      ),
    );
  }

  void _sort() {
    final List<DoseTimeInput> sorted = times.toList()
      ..sort(
        (DoseTimeInput a, DoseTimeInput b) =>
            a.minuteOfDay.compareTo(b.minuteOfDay),
      );
    times.assignAll(sorted);
  }
}
