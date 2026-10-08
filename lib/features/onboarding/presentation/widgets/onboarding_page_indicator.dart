import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Row of page dots for the onboarding carousel. The current dot is wider
/// and filled with the logo gradient; the others are small and neutral.
///
/// [currentPage] is a zero-based index. The row mirrors automatically in
/// RTL, and screen readers hear "Page 2 of 3" instead of the dots.
class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    required this.currentPage,
    required this.pageCount,
    super.key,
  });

  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppStrings.onboardingPageIndicator.trParams(<String, String>{
        'current': (currentPage + 1).toString(),
        'total': pageCount.toString(),
      }),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (int index = 0; index < pageCount; index++)
              _PageDot(isActive: index == currentPage),
          ],
        ),
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return AnimatedContainer(
      duration: AppDurations.normal,
      curve: AppDurations.standardCurve,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXs),
      width: isActive ? AppSizes.pageDotActiveWidth : AppSizes.pageDotSize,
      height: AppSizes.pageDotSize,
      decoration: BoxDecoration(
        gradient: isActive ? colors.actionGradient : null,
        color: isActive ? null : colors.progressTrack,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
    );
  }
}
