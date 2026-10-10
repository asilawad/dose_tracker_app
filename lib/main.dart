import 'package:dose_tracker/app/routes/app.dart';
import 'package:dose_tracker/core/services/language_service.dart';
import 'package:dose_tracker/core/services/onboarding_status_service.dart';
import 'package:dose_tracker/core/services/reminder_settings_service.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// App entry point. The services that read saved device settings are created
/// and registered here, before the first frame, so every screen can use them
/// synchronously. The database and data sources are registered by
/// `InitialBinding`, which `DoseTrackerApp` wires in.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync<SessionService>(SessionService.create, permanent: true);
  await Get.putAsync<LanguageService>(LanguageService.create, permanent: true);
  await Get.putAsync<OnboardingStatusService>(
    OnboardingStatusService.create,
    permanent: true,
  );
  await Get.putAsync<ReminderSettingsService>(
    ReminderSettingsService.create,
    permanent: true,
  );
  runApp(const DoseTrackerApp());
}
