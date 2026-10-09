import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/services/onboarding_status_service.dart';
import 'package:get/get.dart';

/// Decides where the app goes once the splash animation has played.
///
/// A device that has not finished onboarding goes to onboarding; every
/// other launch goes to Log In. This is temporary: the Home step adds the
/// missing case (a still-logged-in account goes straight to Home), because
/// the Home route does not exist yet.
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
    final String route = _onboardingStatus.isCompleted
        ? AppRoutes.logIn
        : AppRoutes.onboarding;
    await Get.offNamed<void>(route);
  }
}
