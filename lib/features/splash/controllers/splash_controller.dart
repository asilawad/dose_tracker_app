import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/services/onboarding_status_service.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:get/get.dart';

/// Decides where the app goes once the splash animation has played.
///
/// A device that has not finished onboarding goes to onboarding; otherwise a
/// still-logged-in account goes straight to Home and everyone else to Log In.
class SplashController extends GetxController {
  SplashController(this._onboardingStatus, this._session);

  final OnboardingStatusService _onboardingStatus;
  final SessionService _session;

  @override
  void onReady() {
    super.onReady();
    _goToNextScreen();
  }

  Future<void> _goToNextScreen() async {
    await Future<void>.delayed(AppDurations.splashTotal);
    final String route;
    if (!_onboardingStatus.isCompleted) {
      route = AppRoutes.onboarding;
    } else if (_session.isLoggedIn) {
      route = AppRoutes.home;
    } else {
      route = AppRoutes.logIn;
    }
    await Get.offNamed<void>(route);
  }
}
