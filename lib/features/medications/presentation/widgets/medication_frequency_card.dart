import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The daily frequency card of Add Medication: a title, a short hint and a
/// plus/minus stepper.
///
/// Changing the number redistributes the dose times evenly over the day.
/// The limits come from the controller, which disables a button at its end.
class MedicationFrequencyCard extends GetView<AddMedicationController> {
  const MedicationFrequencyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Row(
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
                  '${controller.frequency} ${AppStrings.medsFrequencyUnit.tr}',
              onIncrement: controller.canIncreaseFrequency
                  ? controller.increaseFrequency
                  : null,
              onDecrement: controller.canDecreaseFrequency
                  ? controller.decreaseFrequency
                  : null,
              incrementTooltip: AppStrings.a11yFrequencyIncrease.tr,
              decrementTooltip: AppStrings.a11yFrequencyDecrease.tr,
            ),
          ),
        ],
      ),
    );
  }
}
