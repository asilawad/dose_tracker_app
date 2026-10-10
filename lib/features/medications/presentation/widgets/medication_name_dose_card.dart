import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_choice_chip.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The name and dose card of Add Medication: the medication name, the dose
/// amount and the unit chips (mg, IU, ml, pills).
///
/// State and validation come from [AddMedicationController]. The dose
/// field opens a decimal keyboard.
class MedicationNameDoseCard extends GetView<AddMedicationController> {
  const MedicationNameDoseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppTextField(
            label: AppStrings.medsNameLabel.tr,
            hint: AppStrings.medsNameHint.tr,
            controller: controller.nameController,
            prefixIcon: Icons.medication_outlined,
            textInputAction: TextInputAction.next,
            validator: controller.validateName,
          ),
          const SizedBox(height: AppSizes.space2xl),
          AppTextField(
            label: AppStrings.medsDoseLabel.tr,
            hint: AppStrings.medsDoseHint.tr,
            controller: controller.doseController,
            prefixIcon: Icons.scale_outlined,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            validator: controller.validateDose,
          ),
          const SizedBox(height: AppSizes.spaceMd),
          Obx(
            () => Wrap(
              spacing: AppSizes.spaceSm,
              runSpacing: AppSizes.spaceSm,
              children: <Widget>[
                for (final DoseUnit unit in DoseUnit.values)
                  AppChoiceChip(
                    label: _unitKey(unit).tr,
                    selected: unit == controller.doseUnit.value,
                    onTap: () => controller.selectUnit(unit),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _unitKey(DoseUnit unit) {
    return switch (unit) {
      DoseUnit.mg => AppStrings.medsUnitMg,
      DoseUnit.iu => AppStrings.medsUnitIu,
      DoseUnit.ml => AppStrings.medsUnitMl,
      DoseUnit.pills => AppStrings.medsUnitPills,
    };
  }
}
