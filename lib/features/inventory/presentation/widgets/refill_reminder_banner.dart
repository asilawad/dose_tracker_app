import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The warning banner at the bottom of Inventory: how many medications are
/// running low. Tapping it filters the list to those medications, and
/// tapping again shows all of them.
///
/// [count] is the number of medications that need a refill. While
/// [isFiltered] is true the second line says how to show all medications.
class RefillReminderBanner extends StatelessWidget {
  const RefillReminderBanner({
    required this.count,
    required this.isFiltered,
    required this.onTap,
    super.key,
  });

  final int count;
  final bool isFiltered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusCard);
    final String title = AppStrings.inventoryRunningLow.trParams(
      <String, String>{'count': DoseFormatter.quantity(count.toDouble())},
    );
    final String message = isFiltered
        ? AppStrings.inventoryRefillShowAll.tr
        : AppStrings.inventoryRefillSoon.tr;

    return Semantics(
      button: true,
      label: '$title. $message',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.warningTint,
            borderRadius: radius,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: onTap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppSizes.minTapTarget,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.spaceLg),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: AppSizes.pillTileSize,
                        height: AppSizes.pillTileSize,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(
                            AppSizes.pillTileRadius,
                          ),
                        ),
                        child: Icon(
                          Icons.notifications_active_rounded,
                          size: AppSizes.iconMd,
                          color: colors.warning,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spaceMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              title,
                              style: textTheme.titleMedium?.copyWith(
                                fontSize: 15,
                              ),
                            ),
                            Text(message, style: textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: AppSizes.iconLg,
                        color: colors.warning,
                      ),
                    ],
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
