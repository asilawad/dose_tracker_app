import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/logo_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Top bar of the onboarding screens: logo and app name on the leading side,
/// "Skip" on the trailing side. The row mirrors automatically in RTL.
///
/// The app name is shortened with an ellipsis instead of overflowing when
/// the text size is very large. The logo's own label is hidden from screen
/// readers because the app name beside it already says the same thing.
class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({required this.onSkip, super.key});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        const ExcludeSemantics(child: LogoImage(size: AppSizes.logoHeader)),
        const SizedBox(width: AppSizes.spaceSm),
        Expanded(
          child: Text(
            AppStrings.appName.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall,
          ),
        ),
        TextButton(
          onPressed: onSkip,
          style: TextButton.styleFrom(
            foregroundColor: colors.textSecondary,
            minimumSize: const Size(0, AppSizes.minTapTarget),
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
          ),
          child: Text(
            AppStrings.actionSkip.tr,
            style: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
          ),
        ),
      ],
    );
  }
}
