import 'package:dose_tracker/core/constants/storage_keys.dart';
import 'package:dose_tracker/features/notifications/data/models/reminder_settings.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers the reminder choices on this device and publishes changes.
///
/// It is a device-level setting, not account data: logging out or switching
/// accounts keeps it. Screens and the reminder scheduler can react to
/// [current] with `Obx` or `ever`.
///
/// Create it once at startup with
/// `await Get.putAsync(ReminderSettingsService.create, permanent: true)`.
class ReminderSettingsService extends GetxService {
  ReminderSettingsService._(this._preferences) {
    current.value = _read();
  }

  final SharedPreferences _preferences;

  /// The settings in use.
  final Rx<ReminderSettings> current = ReminderSettings.defaults.obs;

  static Future<ReminderSettingsService> create() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return ReminderSettingsService._(preferences);
  }

  Future<void> setEnabled({required bool enabled}) async {
    await _preferences.setBool(StorageKeys.remindersEnabled, enabled);
    current.value = current.value.copyWith(enabled: enabled);
  }

  Future<void> setEscalation(ReminderEscalation escalation) async {
    await _preferences.setInt(
      StorageKeys.reminderEscalationMinutes,
      escalation.minutes,
    );
    current.value = current.value.copyWith(escalation: escalation);
  }

  ReminderSettings _read() {
    return ReminderSettings(
      enabled: _preferences.getBool(StorageKeys.remindersEnabled) ?? true,
      escalation: ReminderEscalation.fromMinutes(
        _preferences.getInt(StorageKeys.reminderEscalationMinutes),
      ),
    );
  }
}
