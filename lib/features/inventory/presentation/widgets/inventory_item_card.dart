import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/inventory/data/models/inventory_item.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:dose_tracker/views/widgets/stock_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One medication in the inventory list: avatar, name with dose, who it is
/// for and its stock total, a switch to pause or resume it, and the stock
/// bar with the count left.
///
/// A medication that does not track stock shows a note instead of the bar.
/// Low stock and paused medications show a labeled badge, so state never
/// relies on color alone. Tapping the card calls [onRestock] (pass null when
/// there is no stock to refill); the switch calls [onActiveChanged].
class InventoryItemCard extends StatelessWidget {
  const InventoryItemCard({
    required this.item,
    required this.onActiveChanged,
    required this.onRestock,
    super.key,
  });

  final InventoryItem item;
  final ValueChanged<bool> onActiveChanged;
  final VoidCallback? onRestock;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double? fraction = item.remainingFraction;
    final String title =
        '${item.medicationName} ${DoseFormatter.quantity(item.doseAmount)} '
        '${item.doseUnit.labelKey.tr}';

    return AppCard(
      onTap: onRestock,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              PersonaAvatar(persona: item.personaColor),
              const SizedBox(width: AppSizes.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    Wrap(
                      spacing: AppSizes.spaceSm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(item.profileName, style: textTheme.bodyMedium),
                        if (fraction != null) ...<Widget>[
                          Container(
                            width: AppSizes.spaceXs,
                            height: AppSizes.spaceXs,
                            decoration: BoxDecoration(
                              color: colors.textSecondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            AppStrings.inventoryTotal.trParams(<String, String>{
                              'count': DoseFormatter.quantity(
                                (item.stockTotal ?? 0).toDouble(),
                              ),
                            }),
                            style: textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Semantics(
                label: title,
                child: Switch(
                  value: item.isActive,
                  onChanged: onActiveChanged,
                  activeTrackColor: colors.active,
                  activeThumbColor: colors.onActive,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMd),
          if (fraction == null)
            Text(AppStrings.inventoryNotTracked.tr, style: textTheme.bodyMedium)
          else
            Row(
              children: <Widget>[
                Expanded(
                  child: StockProgressBar(
                    fraction: fraction,
                    isLow: item.isLowStock,
                  ),
                ),
                const SizedBox(width: AppSizes.spaceMd),
                Text(
                  AppStrings.inventoryLeft.trParams(<String, String>{
                    'count': DoseFormatter.quantity(
                      (item.stockRemaining ?? 0).toDouble(),
                    ),
                  }),
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          if (item.isLowStock || !item.isActive)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.spaceSm),
              child: Wrap(
                spacing: AppSizes.spaceSm,
                runSpacing: AppSizes.spaceXs,
                children: <Widget>[
                  if (item.isLowStock)
                    StatusBadge(
                      label: AppStrings.inventoryLowStock.tr,
                      tone: BadgeTone.danger,
                      icon: Icons.warning_amber_rounded,
                    ),
                  if (!item.isActive)
                    StatusBadge(
                      label: AppStrings.inventoryPaused.tr,
                      tone: BadgeTone.active,
                      icon: Icons.pause_rounded,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
