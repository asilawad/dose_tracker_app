import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:flutter/material.dart';

/// One row of the Settings list: icon, title, optional current value, and a
/// chevron that mirrors in right-to-left.
///
/// Leave [onTap] null for a visible but disabled row (for example the
/// Appearance row). [title] and [value] must already be translated.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    required this.icon,
    required this.title,
    this.value,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool enabled = onTap != null;
    final String? valueText = value;

    return Semantics(
      button: true,
      enabled: enabled,
      label: valueText == null ? title : '$title, $valueText',
      child: ExcludeSemantics(
        child: AppCard(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
            child: Row(
              children: <Widget>[
                _RowIcon(icon: icon, enabled: enabled),
                const SizedBox(width: AppSizes.spaceMd),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.bodyLarge?.copyWith(
                      color: enabled ? null : colors.textSecondary,
                    ),
                  ),
                ),
                if (valueText != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: AppSizes.spaceSm,
                    ),
                    child: Text(valueText, style: textTheme.bodyMedium),
                  ),
                if (enabled)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: AppSizes.spaceSm,
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: AppSizes.iconLg,
                      color: colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RowIcon extends StatelessWidget {
  const _RowIcon({required this.icon, required this.enabled});

  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return Container(
      width: AppSizes.avatarSm,
      height: AppSizes.avatarSm,
      decoration: BoxDecoration(
        color: enabled ? colors.activeTint : colors.progressTrack,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: AppSizes.iconMd,
        color: enabled ? colors.active : colors.textSecondary,
      ),
    );
  }
}
