import 'package:dose_tracker/features/reports/data/models/doctor_report.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';

/// Pure logic that turns a profile's doses over a range into the numbers of
/// the doctor's report. It touches no database and no PDF, so it is easy to
/// test.
///
/// Doses of other profiles are ignored. Pass [medicationId] to keep only one
/// medication. Doses still pending are left out, because they are not due.
/// Medications are listed by name, and doses not taken latest first.
abstract final class ReportBuilder {
  static DoctorReport build({
    required int profileId,
    required String profileName,
    required DateTime from,
    required DateTime to,
    required List<ScheduledDose> doses,
    required int? medicationId,
    required String? notes,
  }) {
    final List<ScheduledDose> due = doses
        .where(
          (ScheduledDose dose) =>
              dose.profileId == profileId &&
              dose.state != DoseState.pending &&
              (medicationId == null || dose.medicationId == medicationId),
        )
        .toList();

    final Map<int, List<ScheduledDose>> byMedication =
        <int, List<ScheduledDose>>{};
    for (final ScheduledDose dose in due) {
      byMedication
          .putIfAbsent(dose.medicationId, () => <ScheduledDose>[])
          .add(dose);
    }

    final List<MedicationReportLine> lines =
        <MedicationReportLine>[
          for (final List<ScheduledDose> group in byMedication.values)
            _lineOf(group),
        ]..sort(
          (MedicationReportLine a, MedicationReportLine b) =>
              a.medicationName.compareTo(b.medicationName),
        );

    final List<MissedDoseEntry> missed =
        <MissedDoseEntry>[
          for (final ScheduledDose dose in due)
            if (dose.state == DoseState.missed ||
                dose.state == DoseState.skipped)
              MissedDoseEntry(
                medicationName: dose.medicationName,
                doseAmount: dose.doseAmount,
                doseUnit: dose.doseUnit,
                scheduledAt: DateTime(
                  dose.date.year,
                  dose.date.month,
                  dose.date.day,
                  0,
                  dose.minuteOfDay,
                ),
                kind: dose.state == DoseState.skipped
                    ? MissedDoseKind.skipped
                    : MissedDoseKind.missed,
                reason: dose.skipReason,
              ),
        ]..sort(
          (MissedDoseEntry a, MissedDoseEntry b) =>
              b.scheduledAt.compareTo(a.scheduledAt),
        );

    final String? trimmedNotes = notes?.trim();
    return DoctorReport(
      profileName: profileName,
      from: from,
      to: to,
      lines: lines,
      missed: missed,
      notes: trimmedNotes == null || trimmedNotes.isEmpty ? null : trimmedNotes,
    );
  }

  static MedicationReportLine _lineOf(List<ScheduledDose> group) {
    int taken = 0;
    int takenLate = 0;
    int skipped = 0;
    int missed = 0;
    for (final ScheduledDose dose in group) {
      switch (dose.state) {
        case DoseState.taken:
          taken++;
        case DoseState.takenLate:
          takenLate++;
        case DoseState.skipped:
          skipped++;
        case DoseState.missed:
          missed++;
        case DoseState.pending:
          break;
      }
    }
    final ScheduledDose first = group.first;
    return MedicationReportLine(
      medicationId: first.medicationId,
      medicationName: first.medicationName,
      doseAmount: first.doseAmount,
      doseUnit: first.doseUnit,
      mealInstruction: first.mealInstruction,
      taken: taken,
      takenLate: takenLate,
      skipped: skipped,
      missed: missed,
    );
  }
}
