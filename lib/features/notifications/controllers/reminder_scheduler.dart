import 'dart:async';

import 'package:dose_tracker/core/services/reminder_service.dart';
import 'package:dose_tracker/core/services/reminder_settings_service.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/inventory/data/models/inventory_item.dart';
import 'package:dose_tracker/features/inventory/data/repositories/inventory_repository.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/notifications/data/models/planned_reminder.dart';
import 'package:dose_tracker/features/notifications/data/models/reminder_results.dart';
import 'package:dose_tracker/features/notifications/data/models/reminder_settings.dart';
import 'package:dose_tracker/features/notifications/data/repositories/reminder_planner.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Keeps the scheduled notifications in step with the data while the main
/// shell is open: it replans the dose reminders whenever a dose, a
/// medication, a profile or the reminder settings change, and shows a
/// "running low" notification when a medication's stock crosses the
/// low-stock level.
///
/// It extends [GetxController] so that GetX removes it with the shell route:
/// on logout it stops listening and clears the scheduled reminders, so they
/// never reach another account. On platforms that cannot show scheduled
/// notifications (anything but Android) it does nothing. The plan covers
/// [ReminderPlanner.windowDays] days from the moment the shell opened, and a
/// plan identical to the last one scheduled is not scheduled again.
class ReminderScheduler extends GetxController {
  ReminderScheduler(
    this._doseLogs,
    this._inventory,
    this._settings,
    this._reminders,
  );

  final DoseLogsRepository _doseLogs;
  final InventoryRepository _inventory;
  final ReminderSettingsService _settings;
  final ReminderService _reminders;

  StreamSubscription<List<ScheduledDose>>? _dosesSubscription;
  StreamSubscription<List<InventoryItem>>? _inventorySubscription;
  Worker? _settingsWorker;

  List<ScheduledDose> _doses = const <ScheduledDose>[];
  List<PlannedReminder> _lastPlan = const <PlannedReminder>[];
  bool _hasScheduled = false;
  bool _isRunning = false;
  bool _needsAnotherRun = false;

  final Set<int> _lowMedicationIds = <int>{};
  bool _inventoryReady = false;

  @override
  void onInit() {
    super.onInit();
    if (!_reminders.isSupported) {
      return;
    }
    unawaited(_askPermissionIfNeeded());
    _dosesSubscription = _doseLogs
        .watchDays(start: DateTime.now(), days: ReminderPlanner.windowDays)
        .listen((List<ScheduledDose> list) {
          _doses = list;
          unawaited(_reschedule());
        });
    _inventorySubscription = _inventory.watchItems().listen(_onInventory);
    _settingsWorker = ever<ReminderSettings>(
      _settings.current,
      (_) => unawaited(_reschedule()),
    );
  }

  Future<void> _askPermissionIfNeeded() async {
    if (!_settings.current.value.enabled) {
      return;
    }
    if (await _reminders.permission() == ReminderPermission.denied) {
      await _reminders.requestPermission();
    }
    await _reschedule();
  }

  Future<void> _reschedule() async {
    if (_isRunning) {
      _needsAnotherRun = true;
      return;
    }
    _isRunning = true;
    try {
      do {
        _needsAnotherRun = false;
        final List<PlannedReminder> plan = ReminderPlanner.plan(
          now: DateTime.now(),
          settings: _settings.current.value,
          doses: _doses,
        );
        if (_hasScheduled && listEquals(plan, _lastPlan)) {
          continue;
        }
        final ScheduleRemindersResult result = await _reminders.scheduleAll(
          plan,
        );
        switch (result) {
          case RemindersScheduled():
            _lastPlan = plan;
            _hasScheduled = true;
          case RemindersUnsupported():
          case RemindersNotAllowed():
          case RemindersFailed():
            _hasScheduled = false;
        }
      } while (_needsAnotherRun);
    } finally {
      _isRunning = false;
    }
  }

  void _onInventory(List<InventoryItem> items) {
    final Set<int> low = <int>{
      for (final InventoryItem item in items)
        if (item.isActive && item.isLowStock) item.medicationId,
    };
    if (_inventoryReady && _settings.current.value.enabled) {
      for (final InventoryItem item in items) {
        final bool becameLow =
            low.contains(item.medicationId) &&
            !_lowMedicationIds.contains(item.medicationId);
        if (becameLow) {
          unawaited(
            _reminders.showLowStock(
              medicationId: item.medicationId,
              medicationLabel:
                  '${item.medicationName} '
                  '${DoseFormatter.quantity(item.doseAmount)} '
                  '${item.doseUnit.labelKey.tr}',
              profileName: item.profileName,
              remaining: item.stockRemaining ?? 0,
            ),
          );
        }
      }
    }
    _lowMedicationIds
      ..clear()
      ..addAll(low);
    _inventoryReady = true;
  }

  @override
  void onClose() {
    _dosesSubscription?.cancel();
    _inventorySubscription?.cancel();
    _settingsWorker?.dispose();
    if (_reminders.isSupported) {
      unawaited(_reminders.scheduleAll(const <PlannedReminder>[]));
    }
    super.onClose();
  }
}
