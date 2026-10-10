import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The inventory card of Add Medication: a switch to track stock and, when
/// it is on, the current stock field with a note about the 10% refill alert.
///
/// The fields slide open and closed with the switch. State and validation
/// come from [AddMedicationController]; the stock is only validated while
/// tracking is on.
class MedicationInventoryCard extends GetView<AddMedicationController> {
  const MedicationInventoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: AppSizes.avatarSm,
                height: AppSizes.avatarSm,
                decoration: BoxDecoration(
                  color: colors.activeTint,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: AppSizes.iconMd,
                  color: colors.active,
                ),
              ),
              const SizedBox(width: AppSizes.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.medsInventoryTitle.tr,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      AppStrings.medsInventorySubtitle.tr,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Obx(
                () => Semantics(
                  label: AppStrings.medsInventoryTitle.tr,
                  child: Switch(
                    value: controller.trackInventory.value,
                    onChanged: controller.setTrackInventory,
                    activeTrackColor: colors.active,
                    activeThumbColor: colors.onActive,
                  ),
                ),
              ),
            ],
          ),
          Obx(
            () => AnimatedSize(
              duration: AppDurations.normal,
              curve: AppDurations.standardCurve,
              alignment: Alignment.topCenter,
              child: controller.trackInventory.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppSizes.spaceLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          AppTextField(
                            label: AppStrings.medsStockLabel.tr,
                            controller: controller.stockController,
                            prefixIcon: Icons.numbers_rounded,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            validator: controller.validateStock,
                          ),
                          const SizedBox(height: AppSizes.spaceMd),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.warningTint,
                              borderRadius: BorderRadius.circular(
                                AppSizes.radiusMd,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSizes.spaceMd),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.notifications_active_outlined,
                                    size: AppSizes.iconMd,
                                    color: colors.warning,
                                  ),
                                  const SizedBox(width: AppSizes.spaceMd),
                                  Expanded(
                                    child: Text(
                                      AppStrings.medsStockNote.tr,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}
