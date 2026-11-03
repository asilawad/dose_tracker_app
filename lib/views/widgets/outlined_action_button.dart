import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/dashed_border_painter.dart';
import 'package:flutter/material.dart';

/// Visual meaning of an [OutlinedActionButton].
enum ActionTone {
  /// Soft violet fill, for secondary actions.
  normal,

  /// Soft red fill, for example "Log out".
  danger,

  /// Solid red fill, the confirm action of a destructive sheet.
  dangerSolid,

  /// Red text without a fill, for example "Delete medication".
  dangerText,

  /// Dashed violet outline, for "add" actions.
  dashed,

  /// Muted text without a fill, the safe choice of a confirm sheet.
  plain,
}

/// Secondary action button in the design's non-gradient styles, picked with
/// [tone]. Disabled when [onPressed] is null. [label] must already be
/// translated.
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

  Color? _fill(AppColorTokens colors) {
    return switch (tone) {
      ActionTone.normal => colors.activeTint,
      ActionTone.danger => colors.dangerTint,
      ActionTone.dangerSolid => colors.danger,
      ActionTone.dangerText || ActionTone.dashed || ActionTone.plain => null,
    };
  }

  Color _content(AppColorTokens colors) {
    return switch (tone) {
      ActionTone.normal || ActionTone.dashed => colors.activeDeep,
      ActionTone.danger || ActionTone.dangerText => colors.danger,
      ActionTone.dangerSolid => colors.onActive,
      ActionTone.plain => colors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final bool enabled = onPressed != null;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusButton);
    final Color contentColor = enabled
        ? _content(colors)
        : colors.textTertiary;

    return SizedBox(
      width: double.infinity,
      height: tone == ActionTone.dangerText
          ? AppSizes.textButtonHeight
          : AppSizes.buttonHeight,
      child: CustomPaint(
        foregroundPainter: tone == ActionTone.dashed
            ? DashedBorderPainter(
                color: colors.borderDashed,
                radius: AppSizes.radiusButton,
              )
            : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: enabled ? _fill(colors) : colors.fieldFill,
            borderRadius: radius,
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
      ),
    );
  }
}
