import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/onboarding/data/models/onboarding_slide.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One onboarding page: a large icon in a tinted circle, a title and a body
/// text, all centered. The title and body are translation keys from the
/// [OnboardingSlide], so the page follows the app language.
///
/// The content scrolls when the screen is short or the text size is large,
/// so nothing is ever cut off. The icon is decorative and hidden from screen
/// readers.
class OnboardingSlideView extends StatelessWidget {
  const OnboardingSlideView({required this.slide, super.key});

  final OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ExcludeSemantics(
              child: Container(
                width: AppSizes.onboardingIllustrationSize,
                height: AppSizes.onboardingIllustrationSize,
                decoration: BoxDecoration(
                  color: colors.activeTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  slide.icon,
                  size: AppSizes.iconHero,
                  color: colors.active,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.space3xl),
            Text(
              slide.titleKey.tr,
              textAlign: TextAlign.center,
              style: textTheme.displayMedium,
            ),
            const SizedBox(height: AppSizes.spaceMd),
            Text(
              slide.bodyKey.tr,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
