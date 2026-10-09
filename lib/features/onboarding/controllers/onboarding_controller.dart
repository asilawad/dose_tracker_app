import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/services/onboarding_status_service.dart';
import 'package:dose_tracker/features/onboarding/data/models/onboarding_slide.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// State of the onboarding carousel: current page, next, and finishing.
///
/// Finishing saves "onboarding done" so it is shown only once, then replaces
/// the screen so the back button cannot return to it. [complete] (used by
/// "Skip" and the "Log In" link) opens Log In. [next] on the last slide (the
/// "Get Started" button) opens Sign Up. In RTL the page view mirrors by
/// itself, so [next] keeps working in Arabic.
class OnboardingController extends GetxController {
  OnboardingController(this._status);

  final OnboardingStatusService _status;

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  int get pageCount => OnboardingSlides.all.length;

  /// Reads [currentPage], so an `Obx` using it rebuilds on page changes.
  bool get isLastPage => currentPage.value == pageCount - 1;

  void onPageChanged(int index) => currentPage.value = index;

  /// Goes to the next slide, or finishes on the last one by opening Sign Up.
  Future<void> next() async {
    if (isLastPage) {
      await _finishAndOpen(AppRoutes.signUp);
      return;
    }
    await pageController.nextPage(
      duration: AppDurations.onboardingPage,
      curve: AppDurations.standardCurve,
    );
  }

  /// Used by "Skip" and the "Log In" link: finishes and opens Log In.
  Future<void> complete() => _finishAndOpen(AppRoutes.logIn);

  Future<void> _finishAndOpen(String route) async {
    await _status.markCompleted();
    await Get.offNamed<void>(route);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
