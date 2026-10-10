import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/views/widgets/stock_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The tinted summary card at the top of Inventory: the stock left across
/// every medication that tracks stock, its percentage and a progress bar.
///
/// [totalRemaining] is the combined count left and [fraction] the part of
/// the combined stock still left, from 0 to 1. Screen readers read the card
/// as one line.
class InventorySummaryCard extends StatelessWidget {
  const InventorySummaryCard({
    required this.totalRemaining,
    required this.fraction,
    super.key,
  });

  final int totalRemaining;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String leftText = AppStrings.inventoryLeft.trParams(<String, String>{
      'count': DoseFormatter.quantity(totalRemaining.toDouble()),
    });
    final String percentText = DoseFormatter.percent(fraction);

    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.activeTint,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: AppSizes.avatarMd,
                    height: AppSizes.avatarMd,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: AppSizes.iconLg,
                      color: colors.active,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppStrings.inventorySummaryTitle.tr,
                          style: textTheme.bodyMedium,
                        ),
                        Text(leftText, style: textTheme.headlineMedium),
                      ],
                    ),
                  ),
                  Text(
                    percentText,
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceMd),
              StockProgressBar(fraction: fraction),
              const SizedBox(height: AppSizes.spaceSm),
              Text(
                AppStrings.inventorySummaryNote.tr,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
