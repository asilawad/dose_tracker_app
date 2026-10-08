import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/services/onboarding_status_service.dart';
import 'package:dose_tracker/features/onboarding/data/models/onboarding_slide.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// State of the onboarding carousel: current page, next, and finishing.
///
/// [complete] only saves "onboarding done". Moving on to Log In or Sign Up
/// is added in the auth step, because those screens do not exist yet and a
/// route is never referenced before its screen. In RTL the page view mirrors
/// by itself, so [next] keeps working in Arabic.
class OnboardingController extends GetxController {
  OnboardingController(this._status);

  final OnboardingStatusService _status;

  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  int get pageCount => OnboardingSlides.all.length;

  /// Reads [currentPage], so an `Obx` using it rebuilds on page changes.
  bool get isLastPage => currentPage.value == pageCount - 1;

  void onPageChanged(int index) => currentPage.value = index;

  /// Goes to the next slide, or finishes on the last one.
  Future<void> next() async {
    if (isLastPage) {
      await complete();
      return;
    }
    await pageController.nextPage(
      duration: AppDurations.onboardingPage,
      curve: AppDurations.standardCurve,
    );
  }

  /// Used by both "Skip" and the last slide's "Get Started".
  Future<void> complete() => _status.markCompleted();

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
