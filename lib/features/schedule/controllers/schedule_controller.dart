import 'dart:async';

import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_log_results.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// State and actions for today's doses.
class ScheduleController extends GetxController with WidgetsBindingObserver {
  ScheduleController(this._doseLogs);

  static const Duration _checkedHold = Duration(milliseconds: 600);

  final DoseLogsRepository _doseLogs;

  final RxList<ScheduledDose> doses = <ScheduledDose>[].obs;
  final RxSet<String> _justChecked = <String>{}.obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  StreamSubscription<List<ScheduledDose>>? _subscription;

  List<ScheduledDose> get visible => doses
      .where(
        (ScheduledDose dose) =>
            dose.state == DoseState.pending ||
            dose.state == DoseState.missed ||
            _justChecked.contains(dose.key),
      )
      .toList();

  final Map<String, int> _checkedLogIds = <String, int>{};

  bool isJustChecked(ScheduledDose dose) => _justChecked.contains(dose.key);

  int get takenCount => doses
      .where(
        (ScheduledDose dose) =>
            dose.state == DoseState.taken || dose.state == DoseState.takenLate,
      )
      .length;

  int get totalCount => doses.length;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _listen();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _listen();
    }
  }

  void retry() => _listen();

  Future<void> check(ScheduledDose dose) async {
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
    _checkedLogIds[dose.key] = result.logId;
    AppSnackbar.undo(AppStrings.scheduleDoseTaken.tr, () => undo(dose));
    Future<void>.delayed(_checkedHold, () {
      _justChecked.remove(dose.key);
    });
  }

  Future<void> undo(ScheduledDose dose) async {
    _justChecked.remove(dose.key);
    final int? logId =
        _checkedLogIds.remove(dose.key) ??
        doses.firstWhereOrNull((ScheduledDose current) => current.key == dose.key)?.logId;
    if (logId != null) {
      await undoDose(logId);
    }
  }

  Future<void> skipDose(ScheduledDose dose, {String? reason}) async {
    _showLogError(
      await _doseLogs.skipDose(
        medicationId: dose.medicationId,
        date: dose.date,
        minuteOfDay: dose.minuteOfDay,
        reason: reason,
      ),
    );
  }

  Future<void> undoDose(int logId) async {
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
    }
  }

  void _listen() {
    hasError.value = false;
    isLoading.value = true;
    _subscription?.cancel();
    _subscription = _doseLogs
        .watchDay(DosePlanner.dayStart(DateTime.now()))
        .listen(
          (List<ScheduledDose> list) {
            doses.assignAll(list);
            hasError.value = false;
            isLoading.value = false;
          },
          onError: (Object _) {
            hasError.value = true;
            isLoading.value = false;
          },
        );
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    super.onClose();
  }
}
