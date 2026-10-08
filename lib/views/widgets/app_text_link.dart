import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Inline text link, for example "Forgot Password?" or "Sign Up".
///
/// Always underlined and drawn in the solid active color, so it never
/// relies on color alone to look tappable. [label] must already be
/// translated. The tap area is at least `AppSizes.minTapTarget` tall.
class AppTextLink extends StatelessWidget {
  const AppTextLink({required this.label, required this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colors.active,
        minimumSize: const Size(0, AppSizes.minTapTarget),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceSm),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: colors.active,
          decoration: TextDecoration.underline,
          decorationColor: colors.active,
        ),
      ),
    );
  }
}
