import 'dart:async';
import 'dart:typed_data';

import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:dose_tracker/features/reports/data/models/doctor_report.dart';
import 'package:dose_tracker/features/reports/data/models/report_range.dart';
import 'package:dose_tracker/features/reports/data/repositories/pdf_report_service.dart';
import 'package:dose_tracker/features/reports/data/repositories/report_builder.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// State and actions of the Doctor's Report screen: the chosen profile, the
/// date range, the optional medication filter, the note to the doctor, and
/// the creation of the PDF.
///
/// The doses of the range (for every profile) are loaded once per range and
/// kept; [report] is built from them on demand, so changing the profile or
/// the medication filter updates the preview without loading again. The PDF
/// is built from the same numbers plus the note, and is handed to the system
/// share sheet.
class ReportController extends GetxController {
  ReportController(this._profiles, this._doseLogs, this._pdf);

  final ProfilesRepository _profiles;
  final DoseLogsRepository _doseLogs;
  final PdfReportService _pdf;

  final TextEditingController notesController = TextEditingController();

  final RxList<Profile> profiles = <Profile>[].obs;
  final Rxn<int> selectedProfileId = Rxn<int>();
  final Rx<ReportInterval> interval = ReportInterval.last30Days.obs;
  final Rxn<ReportRange> customRange = Rxn<ReportRange>();

  /// The medication the report is limited to, or null for all of them.
  final Rxn<int> selectedMedicationId = Rxn<int>();

  final RxList<ScheduledDose> doses = <ScheduledDose>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxBool isGenerating = false.obs;

  StreamSubscription<List<Profile>>? _profilesSubscription;

  /// The chosen profile, or null while the list is empty or loading.
  Profile? get selectedProfile {
    final int? id = selectedProfileId.value;
    for (final Profile profile in profiles) {
      if (profile.id == id) {
        return profile;
      }
    }
    return null;
  }

  /// The date range of the report, today included.
  ReportRange get range {
    final DateTime today = DosePlanner.dayStart(DateTime.now());
    if (interval.value == ReportInterval.custom) {
      return customRange.value ??
          ReportRange.lastDays(ReportInterval.last30Days.days, today);
    }
    return ReportRange.lastDays(interval.value.days, today);
  }

  /// The medications the chosen profile had doses of in the range, for the
  /// filter choices.
  List<MedicationReportLine> get medicationOptions {
    return _buildReport(medicationId: null, notes: null)?.lines ??
        const <MedicationReportLine>[];
  }

  /// The report shown on screen (without the note), or null while no profile
  /// is chosen.
  DoctorReport? get report {
    return _buildReport(medicationId: selectedMedicationId.value, notes: null);
  }

  @override
  void onInit() {
    super.onInit();
    _profilesSubscription = _profiles.watchProfiles().listen(_onProfiles);
    _load();
  }

  void retry() => _load();

  void selectProfile(int id) {
    selectedProfileId.value = id;
    selectedMedicationId.value = null;
  }

  void selectMedication(int? id) {
    selectedMedicationId.value = id;
  }

  /// Chooses one of the fixed ranges (last 7 or 30 days).
  void selectInterval(ReportInterval value) {
    if (value == ReportInterval.custom || value == interval.value) {
      return;
    }
    interval.value = value;
    _load();
  }

  /// Chooses a custom range. The ends are swapped when reversed, and a range
  /// longer than [ReportRange.maxDays] is shortened from its start.
  void setCustomRange(DateTime start, DateTime end) {
    DateTime from = DosePlanner.dayStart(start);
    final DateTime to = DosePlanner.dayStart(end);
    if (from.isAfter(to)) {
      customRange.value = ReportRange(from: to, to: from);
      from = to;
    }
    final DateTime last = from.isAfter(to) ? from : to;
    final DateTime first = DosePlanner.dayStart(
      start.isBefore(end) ? start : end,
    );
    final ReportRange range = ReportRange(from: first, to: last);
    customRange.value = range.days > ReportRange.maxDays
        ? ReportRange(
            from: DateTime(
              last.year,
              last.month,
              last.day - ReportRange.maxDays + 1,
            ),
            to: last,
          )
        : range;
    interval.value = ReportInterval.custom;
    _load();
  }

  /// Builds the PDF with the note and opens the share sheet. Returns true
  /// when the share sheet opened.
  Future<bool> generate() async {
    if (isGenerating.value) {
      return false;
    }
    final DoctorReport? data = _buildReport(
      medicationId: selectedMedicationId.value,
      notes: notesController.text,
    );
    if (data == null || data.isEmpty) {
      return false;
    }

    isGenerating.value = true;
    try {
      final Uint8List bytes = await _pdf.build(data);
      final bool shared = await _pdf.share(bytes, data);
      if (!shared) {
        AppSnackbar.error(AppStrings.reportFailed.tr);
      }
      return shared;
    } on Object {
      AppSnackbar.error(AppStrings.reportFailed.tr);
      return false;
    } finally {
      isGenerating.value = false;
    }
  }

  DoctorReport? _buildReport({
    required int? medicationId,
    required String? notes,
  }) {
    final Profile? profile = selectedProfile;
    if (profile == null) {
      return null;
    }
    final ReportRange current = range;
    return ReportBuilder.build(
      profileId: profile.id,
      profileName: profile.name,
      from: current.from,
      to: current.to,
      doses: doses.toList(),
      medicationId: medicationId,
      notes: notes,
    );
  }

  void _onProfiles(List<Profile> list) {
    profiles.assignAll(list);
    final bool stillExists = list.any(
      (Profile profile) => profile.id == selectedProfileId.value,
    );
    if (!stillExists) {
      selectedProfileId.value = list.isEmpty ? null : list.first.id;
      selectedMedicationId.value = null;
    }
  }

  Future<void> _load() async {
    hasError.value = false;
    isLoading.value = true;
    final ReportRange current = range;
    try {
      final List<ScheduledDose> list = await _doseLogs
          .watchDays(start: current.from, days: current.days)
          .first;
      doses.assignAll(list);
      final int? medicationId = selectedMedicationId.value;
      if (medicationId != null &&
          !medicationOptions.any(
            (MedicationReportLine line) => line.medicationId == medicationId,
          )) {
        selectedMedicationId.value = null;
      }
    } on Object {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _profilesSubscription?.cancel();
    notesController.dispose();
    super.onClose();
  }
}
