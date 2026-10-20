import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/utils/dose_scheduler.dart';
import 'package:dose_tracker/features/medications/data/models/dose_time.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_status.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_window.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';

/// Pure logic that turns medications, dose times and logs into the list of
/// doses for one day. It touches no database, so it is easy to test.
///
/// A dose with a log shows that log's outcome. A dose without one is
/// pending until the next dose time of the same medication (or midnight for
/// the last dose of the day) arrives: from then on it shows as missed. A dose
/// can be recorded only while its window is open. Paused medications and
/// medications of deleted profiles produce no doses.
/// A dose scheduled earlier than the minute its medication was added is not
/// created (unless it already has a log), so adding a medication at noon
/// never creates a missed 8 AM dose.
abstract final class DosePlanner {
  /// A dose taken more than this many minutes after its time is logged as
  /// taken late instead of taken.
  static const int lateGraceMinutes = 60;

  /// The next dose time after [minuteOfDay], or midnight if it is the last.
  static int deadlineMinute(int minuteOfDay, Iterable<int> allMinutes) {
    int deadline = DoseScheduler.minutesPerDay;
    for (final int minute in allMinutes) {
      if (minute > minuteOfDay && minute < deadline) {
        deadline = minute;
      }
    }
    return deadline;
  }

  /// Returns where [now] falls relative to this dose's recording window.
  static DoseWindow windowAt({
    required DateTime date,
    required int minuteOfDay,
    required int deadlineMinute,
    required DateTime now,
  }) {
    if (now.isBefore(_at(date, minuteOfDay))) {
      return DoseWindow.notYetOpen;
    }
    if (now.isBefore(_at(date, deadlineMinute))) {
      return DoseWindow.open;
    }
    return DoseWindow.closed;
  }

  /// Local midnight of the day that contains [value].
  static DateTime dayStart(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  /// The outcome to store when a dose is taken at [takenAt].
  static DoseStatus takenStatus({
    required DateTime date,
    required int minuteOfDay,
    required DateTime takenAt,
  }) {
    final DateTime scheduled = _at(date, minuteOfDay);
    final bool isLate =
        takenAt.difference(scheduled).inMinutes > lateGraceMinutes;
    return isLate ? DoseStatus.takenLate : DoseStatus.taken;
  }

  /// Doses of [date] (local midnight), earliest first. [logs] must hold the
  /// logs of that day.
  static List<ScheduledDose> build({
    required DateTime date,
    required DateTime now,
    required List<Medication> medications,
    required List<Profile> profiles,
    required List<DoseLogRow> logs,
  }) {
    final Map<int, Profile> profilesById = <int, Profile>{
      for (final Profile profile in profiles) profile.id: profile,
    };
    final Map<String, DoseLogRow> logsByDose = <String, DoseLogRow>{
      for (final DoseLogRow log in logs)
        '${log.medicationId}-${log.scheduledMinuteOfDay}': log,
    };

    final List<ScheduledDose> doses = <ScheduledDose>[];
    for (final Medication medication in medications) {
      final Profile? profile = profilesById[medication.profileId];
      if (!medication.isActive || profile == null) {
        continue;
      }
      final DateTime addedAt = _truncateToMinute(medication.createdAt);

      final List<DoseTime> times = medication.doseTimes.toList()
        ..sort(
          (DoseTime a, DoseTime b) => a.minuteOfDay.compareTo(b.minuteOfDay),
        );
      for (int index = 0; index < times.length; index++) {
        final DoseTime time = times[index];
        final int deadlineMinute = index + 1 < times.length
            ? times[index + 1].minuteOfDay
            : DoseScheduler.minutesPerDay;
        final DoseLogRow? log =
            logsByDose['${medication.id}-${time.minuteOfDay}'];
        if (log == null && _at(date, time.minuteOfDay).isBefore(addedAt)) {
          continue;
        }

        doses.add(
          ScheduledDose(
            medicationId: medication.id,
            profileId: profile.id,
            profileName: profile.name,
            personaColor: profile.personaColor,
            profileAvatar: profile.avatar,
            medicationName: medication.name,
            doseAmount: medication.doseAmount,
            doseUnit: medication.doseUnit,
            mealInstruction: medication.mealInstruction,
            date: date,
            minuteOfDay: time.minuteOfDay,
            quantity: time.quantity,
            state: log != null
                ? log.status.state
                : _derivedState(date, deadlineMinute, now),
            isDue:
                windowAt(
                  date: date,
                  minuteOfDay: time.minuteOfDay,
                  deadlineMinute: deadlineMinute,
                  now: now,
                ) ==
                DoseWindow.open,
            logId: log?.id,
            takenAt: log?.takenAt,
            skipReason: log?.skipReason,
          ),
        );
      }
    }

    doses.sort((ScheduledDose a, ScheduledDose b) {
      final int byTime = a.minuteOfDay.compareTo(b.minuteOfDay);
      if (byTime != 0) {
        return byTime;
      }
      final int byProfile = a.profileId.compareTo(b.profileId);
      return byProfile != 0
          ? byProfile
          : a.medicationName.compareTo(b.medicationName);
    });
    return doses;
  }

  static DoseState _derivedState(
    DateTime date,
    int deadlineMinute,
    DateTime now,
  ) {
    final DateTime deadline = _at(date, deadlineMinute);
    return now.isBefore(deadline) ? DoseState.pending : DoseState.missed;
  }

  static DateTime _truncateToMinute(DateTime value) {
    return DateTime(
      value.year,
      value.month,
      value.day,
      value.hour,
      value.minute,
    );
  }

  /// [minutes] after local midnight of [date]; 1440 gives the next midnight.
  static DateTime _at(DateTime date, int minutes) {
    return DateTime(date.year, date.month, date.day, 0, minutes);
  }
}
