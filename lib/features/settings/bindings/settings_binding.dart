import 'package:dose_tracker/core/services/language_service.dart';
import 'package:dose_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:dose_tracker/features/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

/// Provides the [SettingsController] for the Settings tab. It is run by
/// `MainShellBinding`, because the tab lives inside the main shell.
class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        Get.find<LanguageService>(),
        Get.find<AuthRepository>(),
      ),
    );
  }
}
