import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_name_dose_card.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_options_section.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_recipient_row.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_schedule_section.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Add Medication screen: recipient, name and dose, schedule, expandable
/// options, and the Save button.
///
/// It is opened from a profile's page, which passes the profile id, so the
/// back arrow (mirrored in RTL) returns there and a successful save closes
/// it. The controller comes from `AddMedicationBinding`.
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
            Obx(() {
              if (controller.profile.value == null) {
                return const SizedBox.shrink();
              }
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  MedicationRecipientRow(),
                  SizedBox(height: AppSizes.gutter),
                ],
              );
            }),
            const MedicationNameDoseCard(),
            const SizedBox(height: AppSizes.gutter),
            const MedicationScheduleSection(),
            const SizedBox(height: AppSizes.gutter),
            const MedicationOptionsSection(),
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
