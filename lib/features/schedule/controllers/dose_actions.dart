import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_log_results.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:get/get.dart';

/// Shared recording, undo and temporary checked-state behavior for dose lists.
class DoseActions {
  DoseActions(this._doseLogs);

  static const Duration checkedHold = Duration(milliseconds: 600);

  final DoseLogsRepository _doseLogs;
  final RxSet<String> _justChecked = <String>{}.obs;
  final Map<String, int> _logIds = <String, int>{};

  /// Keeps pending and temporarily checked doses in their original order.
  static List<ScheduledDose> filterVisible(
    List<ScheduledDose> doses,
    Set<String> justChecked,
  ) {
    return doses
        .where(
          (ScheduledDose dose) =>
              dose.state == DoseState.pending ||
              justChecked.contains(dose.key),
        )
        .toList();
  }

  /// Returns visible doses and observes temporary checked-state changes.
  List<ScheduledDose> visible(List<ScheduledDose> doses) {
    return filterVisible(doses, _justChecked.toSet());
  }

  bool isJustChecked(ScheduledDose dose) => _justChecked.contains(dose.key);

  Future<void> check(ScheduledDose dose, {bool announce = true}) async {
    if (!dose.canRecord && !isJustChecked(dose)) {
      if (dose.state == DoseState.pending && !dose.isDue) {
        AppSnackbar.error(AppStrings.scheduleNotYetDue.tr);
      }
      return;
    }
    if (!_justChecked.add(dose.key)) {
      return;
    }
    final LogDoseResult result = await _doseLogs.takeDose(
      medicationId: dose.medicationId,
      date: dose.date,
      minuteOfDay: dose.minuteOfDay,
    );
    if (result is! LogDoseSuccess) {
      _justChecked.remove(dose.key);
      _showLogError(result);
      return;
    }
    _logIds[dose.key] = result.logId;
    if (announce) {
      AppSnackbar.undo(AppStrings.scheduleDoseTaken.tr, () => undo(dose));
    }
    Future<void>.delayed(checkedHold, () {
      _justChecked.remove(dose.key);
    });
  }

  Future<void> checkAll(List<ScheduledDose> doses) async {
    final List<ScheduledDose> eligible = doses
        .where((ScheduledDose dose) => dose.canRecord)
        .toList();
    for (final ScheduledDose dose in eligible) {
      await check(dose, announce: false);
    }
    final List<ScheduledDose> recorded = eligible
        .where((ScheduledDose dose) => _logIds.containsKey(dose.key))
        .toList();
    if (recorded.isEmpty) {
      return;
    }
    AppSnackbar.undo(
      AppStrings.scheduleDosesTaken.trParams(<String, String>{
        'count': '${recorded.length}',
      }),
      () async {
        for (final ScheduledDose dose in recorded) {
          await undo(dose);
        }
      },
    );
  }

  Future<void> skip(ScheduledDose dose, {String? reason}) async {
    _showLogError(
      await _doseLogs.skipDose(
        medicationId: dose.medicationId,
        date: dose.date,
        minuteOfDay: dose.minuteOfDay,
        reason: reason,
      ),
    );
  }

  Future<void> undo(ScheduledDose dose) async {
    _justChecked.remove(dose.key);
    final int? logId = _logIds.remove(dose.key) ?? dose.logId;
    if (logId != null) {
      await _undoDose(logId);
    }
  }

  Future<void> _undoDose(int logId) async {
    final UndoDoseResult result = await _doseLogs.undoDose(logId);
    switch (result) {
      case UndoDoseSuccess():
        return;
      case UndoDoseNotFound():
        AppSnackbar.error(AppStrings.stateErrorGeneric.tr);
    }
  }

  void _showLogError(LogDoseResult result) {
    switch (result) {
      case LogDoseSuccess():
        return;
      case LogDoseNotFound():
      case LogDoseFutureDay():
        AppSnackbar.error(AppStrings.stateErrorGeneric.tr);
      case LogDoseNotYetDue():
        AppSnackbar.error(AppStrings.scheduleNotYetDue.tr);
      case LogDoseWindowClosed():
        AppSnackbar.error(AppStrings.scheduleWindowClosed.tr);
    }
  }
}
