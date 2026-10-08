import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/features/onboarding/controllers/onboarding_controller.dart';
import 'package:dose_tracker/features/onboarding/data/models/onboarding_slide.dart';
import 'package:dose_tracker/features/onboarding/presentation/widgets/onboarding_footer.dart';
import 'package:dose_tracker/features/onboarding/presentation/widgets/onboarding_header.dart';
import 'package:dose_tracker/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
import 'package:dose_tracker/features/onboarding/presentation/widgets/onboarding_slide_view.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The three-slide onboarding carousel: header with Skip, swipeable slides,
/// page dots, and the footer with the main button and the Log In link.
///
/// "Skip", "Get Started" and the Log In link only save "onboarding done"
/// for now. The navigation to Log In and Sign Up is added in the auth step,
/// because those screens do not exist yet. The controller is provided by the
/// onboarding binding (next step).
class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: AppSizes.spaceSm),
          OnboardingHeader(onSkip: controller.complete),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: controller.pageCount,
              itemBuilder: (BuildContext context, int index) {
                return OnboardingSlideView(slide: OnboardingSlides.all[index]);
              },
            ),
          ),
          Obx(
            () => OnboardingPageIndicator(
              currentPage: controller.currentPage.value,
              pageCount: controller.pageCount,
            ),
          ),
          const SizedBox(height: AppSizes.space2xl),
          Obx(
            () => OnboardingFooter(
              isLastPage: controller.isLastPage,
              onPrimaryPressed: controller.next,
              onLogInPressed: controller.complete,
            ),
          ),
          const SizedBox(height: AppSizes.spaceLg),
        ],
      ),
    );
  }
}
