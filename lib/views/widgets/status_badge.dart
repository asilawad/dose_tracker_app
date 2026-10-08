import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Meaning of a badge. Colors are status colors, never decoration.
enum BadgeTone { success, warning, danger, active }

/// Small pill label, for example "Low stock", "Taken" or "Missed".
///
/// [label] must already be translated. Add an optional [icon] for status
/// that should not rely on color alone.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    required this.tone,
    this.icon,
    super.key,
  });

  final String label;
  final BadgeTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final (Color background, Color foreground) = switch (tone) {
      BadgeTone.success => (colors.successTint, colors.success),
      BadgeTone.warning => (colors.warningTint, colors.textPrimary),
      BadgeTone.danger => (colors.dangerTint, colors.danger),
      BadgeTone.active => (colors.activeTint, colors.active),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSizes.radiusChip),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spaceSm + AppSizes.spaceXs,
          vertical: AppSizes.spaceXs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, size: AppSizes.iconSm, color: foreground),
              const SizedBox(width: AppSizes.spaceXs),
            ],
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}
