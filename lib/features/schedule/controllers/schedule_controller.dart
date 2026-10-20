import 'dart:async';

import 'package:dose_tracker/features/schedule/controllers/dose_actions.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// State and actions for today's doses.
class ScheduleController extends GetxController with WidgetsBindingObserver {
  ScheduleController(this._doseLogs) : actions = DoseActions(_doseLogs);

  final DoseLogsRepository _doseLogs;
  final DoseActions actions;

  final RxList<ScheduledDose> doses = <ScheduledDose>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  StreamSubscription<List<ScheduledDose>>? _subscription;

  List<ScheduledDose> get visible => actions.visible(doses);

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
