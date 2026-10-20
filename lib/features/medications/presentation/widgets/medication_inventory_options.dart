import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/medications/controllers/medication_form_controller.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicationInventoryOptions extends GetView<MedicationFormController> {
  const MedicationInventoryOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
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
                  value: controller.form.trackInventory.value,
                  onChanged: controller.form.setTrackInventory,
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
            alignment: AlignmentDirectional.topCenter,
            child: controller.form.trackInventory.value
                ? Padding(
                    padding: const EdgeInsets.only(top: AppSizes.spaceLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        AppTextField(
                          label: AppStrings.medsStockLabel.tr,
                          controller: controller.form.stockController,
                          prefixIcon: Icons.numbers_rounded,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: controller.form.validateStock,
                        ),
                        const SizedBox(height: AppSizes.spaceMd),
                        AppTextField(
                          label: AppStrings.medsThresholdLabel.tr,
                          controller: controller.form.thresholdController,
                          prefixIcon: Icons.notifications_active_outlined,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          validator: controller.form.validateThreshold,
                        ),
                        const SizedBox(height: AppSizes.spaceMd),
                        _StockNote(
                          textTheme: textTheme,
                          colors: colors,
                        ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ),
      ],
    );
  }
}

class _StockNote extends StatelessWidget {
  const _StockNote({required this.textTheme, required this.colors});

  final TextTheme textTheme;
  final AppColorTokens colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.warningTint,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
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
    );
  }
}
