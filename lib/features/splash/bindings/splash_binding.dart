import 'package:dose_tracker/core/services/onboarding_status_service.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:dose_tracker/features/splash/controllers/splash_controller.dart';
import 'package:get/get.dart';

/// Provides the [SplashController] when the splash route opens.
///
/// It uses `Get.put` instead of `lazyPut` on purpose: the controller does
/// its work in `onReady`, and nothing on the splash screen reads it, so a
/// lazy controller would never be created and the app would never leave the
/// splash. [OnboardingStatusService] and [SessionService] are registered in
/// `main.dart`.
class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(
      SplashController(
        Get.find<OnboardingStatusService>(),
        Get.find<SessionService>(),
      ),
    );
  }
}
