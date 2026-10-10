import 'package:dose_tracker/core/utils/dose_scheduler.dart';
import 'package:dose_tracker/features/notifications/data/models/planned_reminder.dart';
import 'package:dose_tracker/features/notifications/data/models/reminder_settings.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';

/// Pure logic that turns the upcoming doses into the notifications to
/// schedule. It touches no plugin and no database, so it is easy to test.
///
/// Only pending doses get reminders: the first at the dose time, then (when
/// escalation is on) a repeat every escalation gap until the next dose of
/// the same medication or the end of the day, the same moment the dose turns
/// missed. Reminders already in the past are skipped, and at most
/// [maxReminders] of the earliest ones are kept, because Android limits how
/// many alarms an app can hold.
abstract final class ReminderPlanner {
  /// How many days from today (today included) the plan covers.
  static const int windowDays = 4;

  static const int maxReminders = 400;

  /// The part of an id that holds the repeat number.
  static const int _stepSlots = 64;

  /// The number of distinct medication ids before they wrap around.
  static const int _medicationSlots = 4096;

  /// [doses] must hold the doses of every day in the window, as built by the
  /// dose planner, so each carries its current state.
  static List<PlannedReminder> plan({
    required DateTime now,
    required ReminderSettings settings,
    required List<ScheduledDose> doses,
  }) {
    if (!settings.enabled) {
      return const <PlannedReminder>[];
    }

    final DateTime today = DateTime(now.year, now.month, now.day);
    final Map<String, List<int>> minutesByMedicationDay = <String, List<int>>{};
    for (final ScheduledDose dose in doses) {
      minutesByMedicationDay
          .putIfAbsent(_dayKey(dose), () => <int>[])
          .add(dose.minuteOfDay);
    }
    for (final List<int> minutes in minutesByMedicationDay.values) {
      minutes.sort();
    }

    final List<PlannedReminder> reminders = <PlannedReminder>[];
    for (final ScheduledDose dose in doses) {
      if (dose.state != DoseState.pending) {
        continue;
      }
      final List<int> dayMinutes = minutesByMedicationDay[_dayKey(dose)]!;
      final int deadlineMinute = dayMinutes.firstWhere(
        (int minute) => minute > dose.minuteOfDay,
        orElse: () => DoseScheduler.minutesPerDay,
      );
      final int gap = settings.escalation.minutes;
      final int dayOffset = _daysBetween(today, dose.date);

      for (int step = 0; ; step++) {
        final int minute = dose.minuteOfDay + step * gap;
        if (minute >= deadlineMinute || (step > 0 && gap == 0)) {
          break;
        }
        final DateTime at = DateTime(
          dose.date.year,
          dose.date.month,
          dose.date.day,
          0,
          minute,
        );
        if (at.isAfter(now) && dayOffset >= 0 && dayOffset < windowDays) {
          reminders.add(
            PlannedReminder(
              id: _id(dose, dayOffset, step),
              scheduledAt: at,
              dose: dose,
              step: step,
            ),
          );
        }
        if (gap == 0) {
          break;
        }
      }
    }

    reminders.sort(
      (PlannedReminder a, PlannedReminder b) =>
          a.scheduledAt.compareTo(b.scheduledAt),
    );
    return reminders.length > maxReminders
        ? reminders.sublist(0, maxReminders)
        : reminders;
  }

  static String _dayKey(ScheduledDose dose) {
    return '${dose.medicationId}-${dose.date.year}-${dose.date.month}-'
        '${dose.date.day}';
  }

  static int _daysBetween(DateTime from, DateTime to) {
    return DateTime.utc(
      to.year,
      to.month,
      to.day,
    ).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
  }

  /// Packs the medication, day, time and repeat number into one positive
  /// 31-bit number, so no two reminders of one planning run share an id.
  static int _id(ScheduledDose dose, int dayOffset, int step) {
    final int medication = dose.medicationId % _medicationSlots;
    final int daySlot = medication * windowDays + dayOffset;
    final int minuteSlot =
        daySlot * DoseScheduler.minutesPerDay + dose.minuteOfDay;
    return minuteSlot * _stepSlots + (step % _stepSlots);
  }
}
