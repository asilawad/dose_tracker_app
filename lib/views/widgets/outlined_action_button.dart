import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Visual meaning of an [OutlinedActionButton].
enum ActionTone { normal, danger }

/// Secondary action button: pill with a colored outline and no fill.
///
/// [ActionTone.normal] uses the solid active color (for example "Add Family
/// Member"); [ActionTone.danger] uses the danger color (for example
/// "Delete Profile" or "Log Out"). Disabled when [onPressed] is null.
/// [label] must already be translated.
class OutlinedActionButton extends StatelessWidget {
  const OutlinedActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.tone = ActionTone.normal,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ActionTone tone;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final bool enabled = onPressed != null;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusButton);
    final Color accent = tone == ActionTone.danger
        ? colors.danger
        : colors.active;
    final Color contentColor = enabled ? accent : colors.textSecondary;
    final Color borderColor = enabled ? accent : colors.borderHairline;

    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: radius,
          border: Border.all(
            color: borderColor,
            width: AppSizes.borderEmphasis,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: radius,
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (icon != null) ...<Widget>[
                    Icon(icon, size: AppSizes.iconMd, color: contentColor),
                    const SizedBox(width: AppSizes.spaceSm),
                  ],
                  Text(
                    label,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: contentColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
