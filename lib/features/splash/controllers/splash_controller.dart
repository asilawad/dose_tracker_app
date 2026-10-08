import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/services/onboarding_status_service.dart';
import 'package:get/get.dart';

/// Decides where the app goes once the splash animation has played.
///
/// For now only the first-launch case exists: a device that has not
/// finished onboarding goes to onboarding. The other cases (logged-in
/// account to Home, otherwise Log In) are added in the auth and home steps,
/// because those routes do not exist yet. Until then, after onboarding is
/// done the app simply stays on the splash screen.
class SplashController extends GetxController {
  SplashController(this._onboardingStatus);

  final OnboardingStatusService _onboardingStatus;

  @override
  void onReady() {
    super.onReady();
    _goToNextScreen();
  }

  Future<void> _goToNextScreen() async {
    await Future<void>.delayed(AppDurations.splashTotal);
    if (!_onboardingStatus.isCompleted) {
      await Get.offNamed<void>(AppRoutes.onboarding);
    }
  }
}
