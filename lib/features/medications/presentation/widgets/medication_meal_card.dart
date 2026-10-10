import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_choice_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The optional meal instruction card of Add Medication: before, with or
/// after a meal.
///
/// Tapping the chosen option again clears it, since the field is optional.
/// State comes from [AddMedicationController].
class MedicationMealCard extends GetView<AddMedicationController> {
  const MedicationMealCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.medsMealTitle.tr,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSizes.spaceMd),
          Obx(
            () => Wrap(
              spacing: AppSizes.spaceSm,
              runSpacing: AppSizes.spaceSm,
              children: <Widget>[
                for (final MealInstruction meal in MealInstruction.values)
                  AppChoiceChip(
                    label: meal.labelKey.tr,
                    selected: meal == controller.mealInstruction.value,
                    showCheck: true,
                    onTap: () => controller.selectMeal(meal),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
