import 'package:dose_tracker/core/services/onboarding_status_service.dart';
import 'package:dose_tracker/features/onboarding/controllers/onboarding_controller.dart';
import 'package:get/get.dart';

/// Provides the [OnboardingController] when the onboarding route opens and
/// removes it when the route closes (GetX does this automatically).
///
/// It needs [OnboardingStatusService], which `main.dart` registers at
/// startup. That registration is added in the step that opens this route, so
/// nothing can reach this binding before the service exists.
class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(Get.find<OnboardingStatusService>()),
    );
  }
}
