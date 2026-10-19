import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/views/widgets/app_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicationFrequencyRow extends GetView<AddMedicationController> {
  const MedicationFrequencyRow({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStrings.medsFrequencyTitle.tr,
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSizes.spaceXs),
              Text(
                AppStrings.medsFrequencySubtitle.tr,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSizes.spaceMd),
        Obx(
          () => AppStepper(
            valueLabel:
                '${controller.form.frequency} ${AppStrings.medsFrequencyUnit.tr}',
            onIncrement: controller.form.canIncreaseFrequency
                ? controller.form.increaseFrequency
                : null,
            onDecrement: controller.form.canDecreaseFrequency
                ? controller.form.decreaseFrequency
                : null,
            incrementTooltip: AppStrings.a11yFrequencyIncrease.tr,
            decrementTooltip: AppStrings.a11yFrequencyDecrease.tr,
          ),
        ),
      ],
    );
  }
}
