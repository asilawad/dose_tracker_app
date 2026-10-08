import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/views/widgets/app_text_link.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Bottom area of the onboarding screens: the main button ("Next", or "Get
/// Started" on the last slide) and the "Already have an account? Log In"
/// line. The arrow icon mirrors automatically in RTL.
///
/// The line wraps to a second row instead of overflowing when the text is
/// long (Arabic) or the text size is large.
class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({
    required this.isLastPage,
    required this.onPrimaryPressed,
    required this.onLogInPressed,
    super.key,
  });

  final bool isLastPage;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onLogInPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GradientButton(
          label: isLastPage
              ? AppStrings.actionGetStarted.tr
              : AppStrings.actionNext.tr,
          icon: Icons.arrow_forward_rounded,
          onPressed: onPrimaryPressed,
        ),
        const SizedBox(height: AppSizes.spaceMd),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text(
              AppStrings.onboardingHaveAccount.tr,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            AppTextLink(
              label: AppStrings.authLogIn.tr,
              onPressed: onLogInPressed,
            ),
          ],
        ),
      ],
    );
  }
}
