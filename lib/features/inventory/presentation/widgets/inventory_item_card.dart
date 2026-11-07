import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/inventory/data/models/inventory_item.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_switch.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One medication in the inventory list: avatar, name with dose, who it is
/// for, a switch to pause or resume it, and the count left.
///
/// A medication that does not track stock shows a note instead of the count.
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
    final String amount =
        '${DoseFormatter.quantity(item.doseAmount)} ${item.doseUnit.labelKey.tr}';
    final String title = '${item.medicationName} $amount';

    return AppCard(
      onTap: onRestock,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              PersonaAvatar(
                persona: item.personaColor,
                size: PersonaAvatarSize.small,
                avatar: item.profileAvatar,
                name: item.profileName,
              ),
              const SizedBox(width: AppSizes.gutter),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(text: item.medicationName),
                          const TextSpan(text: ' '),
                          TextSpan(text: amount, style: textTheme.bodyMedium),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    Text(item.profileName, style: textTheme.bodySmall),
                  ],
                ),
              ),
              AppSwitch(
                value: item.isActive,
                onChanged: onActiveChanged,
                semanticLabel: title,
              ),
            ],
          ),
          if (!item.tracksStock)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.gutter),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.visibility_off_rounded,
                    size: 18,
                    color: colors.textTertiary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      AppStrings.inventoryNotTracked.tr,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.spaceMd),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: AppSizes.spaceXs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          AppStrings.inventoryLeft.trParams(<String, String>{
                            'count': DoseFormatter.quantity(
                              (item.stockRemaining ?? 0).toDouble(),
                            ),
                          }),
                          style: textTheme.titleLarge?.copyWith(
                            color: item.isLowStock ? colors.danger : null,
                          ),
                        ),
                        if (item.isLowStock)
                          StatusBadge(
                            label: AppStrings.inventoryLowStock.tr,
                            tone: BadgeTone.danger,
                            icon: Icons.warning_rounded,
                          ),
                      ],
                    ),
                  ),
                  if (onRestock != null)
                    _RefillChip(
                      highlighted: item.isLowStock,
                      onTap: onRestock!,
                    ),
                ],
              ),
            ),
          if (!item.isActive)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.spaceSm),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: StatusBadge(
                  label: AppStrings.inventoryPaused.tr,
                  tone: BadgeTone.active,
                  icon: Icons.pause_rounded,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The "Refill" pill at the end of a tracked card (design `.chip`).
class _RefillChip extends StatelessWidget {
  const _RefillChip({required this.highlighted, required this.onTap});

  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final Color foreground = highlighted
        ? colors.onActive
        : colors.textSecondary;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusChip);

    return Material(
      color: highlighted ? colors.active : colors.fieldFill,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: SizedBox(
          height: AppSizes.chipHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceLg),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(Icons.add_circle_rounded, size: 18, color: foreground),
                const SizedBox(width: 6),
                Text(
                  AppStrings.inventoryRefillAction.tr,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: foreground,
                    fontSize: 14,
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
