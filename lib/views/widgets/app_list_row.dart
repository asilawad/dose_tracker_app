import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:flutter/material.dart';

/// A card holding [AppListRow]s separated by hairlines (design `.card` with
/// `.row` children).
class AppListGroup extends StatelessWidget {
  const AppListGroup({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < children.length; i++) ...<Widget>[
            if (i > 0)
              Divider(
                height: AppSizes.borderHairline,
                thickness: AppSizes.borderHairline,
                color: colors.borderHairline,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// One row of a grouped list, such as Settings: icon, title, optional subtitle and current
/// value, and a chevron that mirrors in right-to-left.
///
/// Leave [onTap] null for a visible but disabled row (for example the
/// Appearance row), whose [value] shows as a pill. [title], [subtitle] and
/// [value] must already be translated.
class AppListRow extends StatelessWidget {
  const AppListRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.onTap,
    this.iconColor,
    this.iconBackground,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? iconBackground;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool enabled = onTap != null;
    final String? valueText = value;

    return Semantics(
      button: true,
      enabled: enabled,
      label: <String>[title, ?subtitle, ?valueText].join(', '),
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Opacity(
            opacity: enabled ? 1 : 0.55,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spaceXs,
                vertical: AppSizes.spaceMd,
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: AppSizes.avatarSm,
                    height: AppSizes.avatarSm,
                    decoration: BoxDecoration(
                      color: enabled
                          ? iconBackground ?? colors.activeTint
                          : colors.fieldFill,
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                    ),
                    child: Icon(
                      icon,
                      size: AppSizes.iconMd,
                      color: enabled
                          ? iconColor ?? colors.activeDeep
                          : colors.textTertiary,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title,
                          style: textTheme.bodyLarge?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (subtitle != null)
                          Text(subtitle!, style: textTheme.bodySmall),
                      ],
                    ),
                  ),
                  if (valueText != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: AppSizes.spaceSm,
                      ),
                      child: enabled
                          ? Text(
                              valueText,
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 14,
                              ),
                            )
                          : StatusBadge(
                              label: valueText,
                              tone: BadgeTone.neutral,
                            ),
                    ),
                  if (enabled)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: AppSizes.spaceSm,
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: AppSizes.iconLg,
                        color: colors.textTertiary,
                      ),
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
