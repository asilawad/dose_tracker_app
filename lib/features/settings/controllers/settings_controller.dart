import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/services/language_service.dart';
import 'package:dose_tracker/core/services/reminder_service.dart';
import 'package:dose_tracker/core/services/reminder_settings_service.dart';
import 'package:dose_tracker/core/translations/app_translations.dart';
import 'package:dose_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:dose_tracker/features/notifications/data/models/reminder_settings.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Actions of the Settings tab: switching the language, the reminder
/// choices and logging out.///
/// Logging out only clears the session pointer (the repository does that),
/// so the account's data stays on the device and comes back at the next
/// login. The whole navigation stack is then replaced with Log In.
class SettingsController extends GetxController {
  SettingsController(
    this._language,
    this._auth,
    this._reminderSettings,
    this._reminders,
  );

  final LanguageService _language;
  final AuthRepository _auth;
  final ReminderSettingsService _reminderSettings;
  final ReminderService _reminders;

  /// The reminder choices, for rows and sheets that show them with `Obx`.
  Rx<ReminderSettings> get reminderSettings => _reminderSettings.current;

  /// Whether the system lets the app show notifications. It starts as
  /// unsupported; call [refreshPermission] when a screen that shows it opens.
  final Rx<ReminderPermission> permission = ReminderPermission.unsupported.obs;

  /// The language in use, for rows that show it with `Obx`.
  Rx<Locale> get currentLocale => _language.current;

  /// Name of [locale] written in its own language, so a user can always
  /// find theirs in the list.
  String languageName(Locale locale) {
    return locale.languageCode == AppTranslations.arabic.languageCode
        ? AppStrings.languageArabicName.tr
        : AppStrings.languageEnglishName.tr;
  }

  Future<void> changeLanguage(Locale locale) {
    return _language.changeLanguage(locale);
  }

  void openCalendar() {
    Get.toNamed<void>(AppRoutes.calendar);
  }

  void openReport() {
    Get.toNamed<void>(AppRoutes.report);
  }

  Future<void> refreshPermission() async {
    permission.value = await _reminders.permission();
  }

  Future<void> requestPermission() async {
    permission.value = await _reminders.requestPermission();
  }

  /// Turns dose reminders on or off. Turning them on also asks the system
  /// for the notification permission.
  Future<void> setRemindersEnabled({required bool enabled}) async {
    await _reminderSettings.setEnabled(enabled: enabled);
    if (enabled) {
      await requestPermission();
    }
  }

  Future<void> setEscalation(ReminderEscalation escalation) {
    return _reminderSettings.setEscalation(escalation);
  }

  Future<void> logOut() async {
    await _auth.signOut();
    await Get.offAllNamed<void>(AppRoutes.logIn);
  }
}
