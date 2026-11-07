import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Amber Home card shown while [count] medications run low, the same count
/// as the cabinet's refill reminder. Tapping it calls [onTap], which opens
/// the cabinet.
class HomeLowStockCard extends StatelessWidget {
  const HomeLowStockCard({required this.count, required this.onTap, super.key});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme text = Theme.of(context).textTheme;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusCard);
    final String title = AppStrings.homeLowStockTitle.trParams(<String, String>{
      'count': '$count',
    });
    final String message = AppStrings.homeLowStockMessage.tr;

    return Semantics(
      button: true,
      label: '$title. $message',
      child: ExcludeSemantics(
        child: Material(
          color: colors.warningTint,
          borderRadius: radius,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
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
                          style: text.titleMedium?.copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: 2),
                        Text(message, style: text.bodyMedium),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: colors.warning),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
