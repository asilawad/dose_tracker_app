import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:flutter/foundation.dart';

/// One notification the app plans to show: when, for which dose, and which
/// repeat of that dose it is.
///
/// [step] is 0 for the reminder at the dose time and 1, 2 and so on for the
/// repeats after it. [id] is the notification id: it is the same for the
/// same dose and step, and different for any other within one planning run.
@immutable
class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.scheduledAt,
    required this.dose,
    required this.step,
  });

  final int id;
  final DateTime scheduledAt;
  final ScheduledDose dose;
  final int step;

  bool get isRepeat => step > 0;

  @override
  bool operator ==(Object other) {
    return other is PlannedReminder &&
        other.id == id &&
        other.scheduledAt == scheduledAt &&
        other.dose == dose &&
        other.step == step;
  }

  @override
  int get hashCode => Object.hash(id, scheduledAt, dose, step);
}
