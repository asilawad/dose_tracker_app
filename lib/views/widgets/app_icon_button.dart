import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';

/// Circular icon button used in headers. [tooltip] must already be
/// translated. Set [ghost] to drop the white surface, and [danger] for a
/// destructive action.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.ghost = false,
    this.danger = false,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool ghost;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return Tooltip(
      message: tooltip,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: ghost ? null : colors.surface,
          shape: BoxShape.circle,
          boxShadow: ghost ? null : AppShadows.soft(colors),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox.square(
              dimension: AppSizes.iconButtonSize,
              child: Icon(
                icon,
                size: AppSizes.iconLg,
                color: danger ? colors.danger : colors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
