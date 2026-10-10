import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_frequency_card.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_inventory_card.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_meal_card.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_name_dose_card.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_recipient_card.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_schedule_card.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Add Medication screen: back arrow, title and the form cards (who it
/// is for, name and dose, daily frequency, schedule, meal instruction,
/// inventory) followed by the Save button.
///
/// It is opened on top of the main shell, so the back arrow (mirrored in
/// RTL) returns there, and a successful save closes it. The controller
/// comes from `AddMedicationBinding`.
class AddMedicationView extends GetView<AddMedicationController> {
  const AddMedicationView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return ScreenScaffold(
      appBar: AppBar(
        backgroundColor: colors.appBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: AppStrings.actionBack.tr,
          onPressed: () => Get.back<void>(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          AppStrings.medsAddTitle.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceLg),
          children: <Widget>[
            const MedicationRecipientCard(),
            const SizedBox(height: AppSizes.gutter),
            const MedicationNameDoseCard(),
            const SizedBox(height: AppSizes.gutter),
            const MedicationFrequencyCard(),
            const SizedBox(height: AppSizes.gutter),
            const MedicationScheduleCard(),
            const SizedBox(height: AppSizes.gutter),
            const MedicationMealCard(),
            const SizedBox(height: AppSizes.gutter),
            const MedicationInventoryCard(),
            const SizedBox(height: AppSizes.space2xl),
            Obx(
              () => GradientButton(
                label: AppStrings.medsSave.tr,
                icon: Icons.check_circle_outline_rounded,
                isLoading: controller.isLoading.value,
                onPressed: controller.submit,
              ),
            ),
            const SizedBox(height: AppSizes.space2xl),
          ],
        ),
      ),
    );
  }
}
