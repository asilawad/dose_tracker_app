import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/utils/dose_scheduler.dart';
import 'package:dose_tracker/features/medications/data/models/dose_time.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';

/// Pure helpers shared by the medication repositories: turning database rows
/// into [Medication] objects and checking a schedule. No database access.
abstract final class MedicationMapper {
  /// True when [times] is not empty, every time is inside the day with a
  /// quantity above zero, and no minute is used twice.
  static bool isValidSchedule(List<DoseTimeInput> times) {
    if (times.isEmpty) {
      return false;
    }
    final Set<int> seen = <int>{};
    for (final DoseTimeInput time in times) {
      final bool inRange =
          time.minuteOfDay >= 0 &&
          time.minuteOfDay < DoseScheduler.minutesPerDay;
      if (!inRange || time.quantity <= 0 || !seen.add(time.minuteOfDay)) {
        return false;
      }
    }
    return true;
  }

  /// Joins each medication row with its dose times (earliest first as the
  /// data source returns them).
  static List<Medication> combine(
    List<MedicationRow> medications,
    List<DoseTimeRow> times,
  ) {
    final Map<int, List<DoseTime>> timesByMedication = <int, List<DoseTime>>{};
    for (final DoseTimeRow row in times) {
      timesByMedication
          .putIfAbsent(row.medicationId, () => <DoseTime>[])
          .add(toDoseTime(row));
    }
    return medications
        .map(
          (MedicationRow row) => Medication(
            id: row.id,
            profileId: row.profileId,
            name: row.name,
            doseAmount: row.doseAmount,
            doseUnit: row.doseUnit,
            mealInstruction: row.mealInstruction,
            trackInventory: row.trackInventory,
            stockThreshold: row.stockThreshold,
            stockRemaining: row.stockRemaining,
            isActive: row.isActive,
            createdAt: row.createdAt,
            doseTimes: timesByMedication[row.id] ?? const <DoseTime>[],
          ),
        )
        .toList();
  }

  static DoseTime toDoseTime(DoseTimeRow row) {
    return DoseTime(
      id: row.id,
      minuteOfDay: row.minuteOfDay,
      quantity: row.quantity,
    );
  }
}
