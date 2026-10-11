import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:flutter/foundation.dart';

/// Why a dose appears in the report's list of doses not taken.
enum MissedDoseKind { missed, skipped }

/// The numbers of one medication over the report range.
///
/// [prescribed] counts only the doses that were already due, so doses still
/// pending are left out. [taken] is on time and [takenLate] is late; both
/// count as taken for the adherence [rate].
@immutable
class MedicationReportLine {
  const MedicationReportLine({
    required this.medicationId,
    required this.medicationName,
    required this.doseAmount,
    required this.doseUnit,
    required this.mealInstruction,
    required this.taken,
    required this.takenLate,
    required this.skipped,
    required this.missed,
  });

  final int medicationId;
  final String medicationName;
  final double doseAmount;
  final DoseUnit doseUnit;
  final MealInstruction? mealInstruction;
  final int taken;
  final int takenLate;
  final int skipped;
  final int missed;

  int get takenTotal => taken + takenLate;

  int get notTaken => skipped + missed;

  int get prescribed => takenTotal + notTaken;

  /// The share of due doses that were taken, from 0 to 1, or null when no
  /// dose was due.
  double? get rate => prescribed == 0 ? null : takenTotal / prescribed;
}

/// One dose that was skipped or missed, for the list of doses not taken.
@immutable
class MissedDoseEntry {
  const MissedDoseEntry({
    required this.medicationName,
    required this.doseAmount,
    required this.doseUnit,
    required this.scheduledAt,
    required this.kind,
    required this.reason,
  });

  final String medicationName;
  final double doseAmount;
  final DoseUnit doseUnit;
  final DateTime scheduledAt;
  final MissedDoseKind kind;

  /// The reason the user gave when skipping, if any.
  final String? reason;
}

/// Everything the doctor's report shows for one profile over a date range.
///
/// [from] and [to] are local midnights and both days are included. [lines]
/// has one entry per medication that had doses in the range, and [missed]
/// lists the doses not taken, latest first. [notes] is the user's optional
/// note to the doctor.
@immutable
class DoctorReport {
  const DoctorReport({
    required this.profileName,
    required this.from,
    required this.to,
    required this.lines,
    required this.missed,
    required this.notes,
  });

  final String profileName;
  final DateTime from;
  final DateTime to;
  final List<MedicationReportLine> lines;
  final List<MissedDoseEntry> missed;
  final String? notes;

  int get prescribed => lines.fold(
    0,
    (int sum, MedicationReportLine line) => sum + line.prescribed,
  );

  int get takenTotal => lines.fold(
    0,
    (int sum, MedicationReportLine line) => sum + line.takenTotal,
  );

  int get takenLate => lines.fold(
    0,
    (int sum, MedicationReportLine line) => sum + line.takenLate,
  );

  /// Doses skipped or missed.
  int get notTaken => lines.fold(
    0,
    (int sum, MedicationReportLine line) => sum + line.notTaken,
  );

  /// The overall share of due doses that were taken, from 0 to 1, or null
  /// when no dose was due.
  double? get rate => prescribed == 0 ? null : takenTotal / prescribed;

  bool get isEmpty => lines.isEmpty;
}
