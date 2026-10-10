import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:flutter/foundation.dart';

/// One dose of one medication on one day, as the schedule shows it: who it
/// is for, what to take, when, and its current [state].
///
/// It is built by the planner from medications and logs, never stored.
/// [date] is local midnight of the day. [logId] and [takenAt] are set only
/// when a log exists (so the dose can be undone).
@immutable
class ScheduledDose {
  const ScheduledDose({
    required this.medicationId,
    required this.profileId,
    required this.profileName,
    required this.personaColor,
    required this.medicationName,
    required this.doseAmount,
    required this.doseUnit,
    required this.mealInstruction,
    required this.date,
    required this.minuteOfDay,
    required this.quantity,
    required this.state,
    required this.logId,
    required this.takenAt,
  });

  final int medicationId;
  final int profileId;
  final String profileName;
  final PersonaColor personaColor;
  final String medicationName;
  final double doseAmount;
  final DoseUnit doseUnit;
  final MealInstruction? mealInstruction;
  final DateTime date;
  final int minuteOfDay;
  final double quantity;
  final DoseState state;
  final int? logId;
  final DateTime? takenAt;

  /// Identifies this dose in a list: a medication has one dose per time.
  String get key => '$medicationId-$minuteOfDay';

  @override
  bool operator ==(Object other) {
    return other is ScheduledDose &&
        other.medicationId == medicationId &&
        other.profileId == profileId &&
        other.profileName == profileName &&
        other.personaColor == personaColor &&
        other.medicationName == medicationName &&
        other.doseAmount == doseAmount &&
        other.doseUnit == doseUnit &&
        other.mealInstruction == mealInstruction &&
        other.date == date &&
        other.minuteOfDay == minuteOfDay &&
        other.quantity == quantity &&
        other.state == state &&
        other.logId == logId &&
        other.takenAt == takenAt;
  }

  @override
  int get hashCode => Object.hash(
    medicationId,
    profileId,
    profileName,
    personaColor,
    medicationName,
    doseAmount,
    doseUnit,
    mealInstruction,
    date,
    minuteOfDay,
    quantity,
    state,
    logId,
    takenAt,
  );
}
