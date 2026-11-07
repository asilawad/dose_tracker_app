import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/medications/controllers/medication_form_controller.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/views/widgets/app_segment_option.dart';
import 'package:dose_tracker/views/widgets/app_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicationMealOptions extends GetView<MedicationFormController> {
  const MedicationMealOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          AppStrings.medsMealTitle.tr,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSizes.spaceSm),
        Obx(
          () => AppSegmentedControl<MealInstruction>(
            options: <AppSegmentOption<MealInstruction>>[
              for (final MealInstruction meal in MealInstruction.values)
                AppSegmentOption<MealInstruction>(
                  value: meal,
                  label: meal.labelKey.tr,
                ),
            ],
            selected: controller.form.mealInstruction.value,
            onChanged: controller.form.selectMeal,
          ),
        ),
      ],
    );
  }
}
