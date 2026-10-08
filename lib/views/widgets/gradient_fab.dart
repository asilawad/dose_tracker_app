import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Round floating action button filled with the logo gradient.
///
/// [tooltip] is required and must already be translated: it is the
/// accessibility label for an icon-only control. The shadow is drawn on the
/// outer [DecoratedBox] and only the ink is clipped to the circle, so the
/// shadow is never cut off. Lists under it should add
/// `AppSizes.bottomOverlayClearance` bottom padding.
class GradientFab extends StatelessWidget {
  const GradientFab({
    required this.onPressed,
    required this.tooltip,
    this.icon = Icons.add_rounded,
    super.key,
  });

  final VoidCallback onPressed;
  final String tooltip;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: ExcludeSemantics(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: colors.actionGradient,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colors.shadowActive,
                  blurRadius: AppSizes.shadowBlurActive,
                  offset: const Offset(0, AppSizes.shadowOffsetYActive),
                ),
              ],
            ),
            child: ClipOval(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onPressed,
                  child: SizedBox(
                    width: AppSizes.fabSize,
                    height: AppSizes.fabSize,
                    child: Icon(
                      icon,
                      size: AppSizes.iconLg,
                      color: colors.onActive,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
