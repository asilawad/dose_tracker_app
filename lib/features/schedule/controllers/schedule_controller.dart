import 'dart:async';

import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_log_results.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:get/get.dart';

/// State and actions of the Schedule tab: the chosen day, the week shown in
/// the day strip, the live list of that day's doses, and the loading and
/// error flags.
///
/// The list updates by itself when a dose is recorded, because it listens to
/// the repository stream; choosing another day listens to that day instead.
/// Doses of a day after today cannot be recorded, so the actions do nothing
/// there (the screen also disables them). Pressing a taken dose again
/// undoes it; any other dose is taken.
class ScheduleController extends GetxController {
  ScheduleController(this._doseLogs);

  final DoseLogsRepository _doseLogs;

  /// The week in the day strip starts on this weekday.
  static const int weekStartWeekday = DateTime.sunday;

  final Rx<DateTime> selectedDate = DosePlanner.dayStart(DateTime.now()).obs;
  final RxList<ScheduledDose> doses = <ScheduledDose>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  StreamSubscription<List<ScheduledDose>>? _subscription;

  /// The seven days of the week that contains the chosen day.
  List<DateTime> get weekDays {
    final DateTime day = selectedDate.value;
    final int offset = (day.weekday - weekStartWeekday) % DateTime.daysPerWeek;
    return <DateTime>[
      for (int index = 0; index < DateTime.daysPerWeek; index++)
        DateTime(day.year, day.month, day.day - offset + index),
    ];
  }

  bool get isToday => selectedDate.value == _today;

  bool get isFutureDay => selectedDate.value.isAfter(_today);

  DateTime get _today => DosePlanner.dayStart(DateTime.now());

  @override
  void onInit() {
    super.onInit();
    _listen();
  }

  void retry() => _listen();

  void selectDate(DateTime date) {
    final DateTime day = DosePlanner.dayStart(date);
    if (day == selectedDate.value) {
      return;
    }
    selectedDate.value = day;
    _listen();
  }

  void goToToday() => selectDate(DateTime.now());

  /// Moves the chosen day by whole weeks (negative goes back).
  void shiftWeeks(int weeks) {
    final DateTime day = selectedDate.value;
    selectDate(
      DateTime(day.year, day.month, day.day + weeks * DateTime.daysPerWeek),
    );
  }

  /// Takes a pending, missed or skipped dose, or undoes a taken one.
  Future<void> toggleDose(ScheduledDose dose) async {
    if (isFutureDay) {
      return;
    }
    final bool wasTaken =
        dose.state == DoseState.taken || dose.state == DoseState.takenLate;
    if (wasTaken) {
      await undoDose(dose);
      return;
    }
    _showLogError(
      await _doseLogs.takeDose(
        medicationId: dose.medicationId,
        date: dose.date,
        minuteOfDay: dose.minuteOfDay,
      ),
    );
  }

  Future<void> skipDose(ScheduledDose dose, {String? reason}) async {
    if (isFutureDay) {
      return;
    }
    _showLogError(
      await _doseLogs.skipDose(
        medicationId: dose.medicationId,
        date: dose.date,
        minuteOfDay: dose.minuteOfDay,
        reason: reason,
      ),
    );
  }

  /// Puts a recorded dose back to pending.
  Future<void> undoDose(ScheduledDose dose) async {
    final int? logId = dose.logId;
    if (logId == null) {
      return;
    }
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
        .watchDay(selectedDate.value)
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
    _subscription?.cancel();
    super.onClose();
  }
}
