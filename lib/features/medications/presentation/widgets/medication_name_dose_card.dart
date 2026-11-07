import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/medications/controllers/medication_form_controller.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_segment_option.dart';
import 'package:dose_tracker/views/widgets/app_segmented_control.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The name and dose card of Add Medication: the medication name, the dose
/// amount and the unit chips (mg, IU, ml, pills).
///
/// State and validation come from the controller's form fields.
class MedicationNameDoseCard extends GetView<MedicationFormController> {
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
            controller: controller.form.nameController,
            prefixIcon: Icons.medication_rounded,
            textInputAction: TextInputAction.next,
            validator: controller.form.validateName,
          ),
          const SizedBox(height: AppSizes.spaceLg),
          AppTextField(
            label: AppStrings.medsDoseLabel.tr,
            hint: AppStrings.medsDoseHint.tr,
            controller: controller.form.doseController,
            prefixIcon: Icons.scale_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            validator: controller.form.validateDose,
          ),
          const SizedBox(height: AppSizes.spaceMd),
          Obx(
            () => AppSegmentedControl<DoseUnit>(
              options: <AppSegmentOption<DoseUnit>>[
                for (final DoseUnit unit in DoseUnit.values)
                  AppSegmentOption<DoseUnit>(
                    value: unit,
                    label: unit.labelKey.tr,
                  ),
              ],
              selected: controller.form.doseUnit.value,
              onChanged: controller.form.selectUnit,
            ),
          ),
        ],
      ),
    );
  }
}
