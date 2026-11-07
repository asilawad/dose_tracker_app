import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/medications/controllers/medication_form_controller.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_name_dose_card.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_options_section.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_recipient_row.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_schedule_section.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/app_inner_header.dart';
import 'package:dose_tracker/views/widgets/confirm_sheet_content.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:dose_tracker/views/widgets/sticky_cta.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Shared Add and Edit Medication form: recipient, name and dose, schedule,
/// expandable options, the Save button and, when editing, Delete medication.
///
/// It is opened from a profile's page, which passes the profile id, so the
/// back arrow (mirrored in RTL) returns there and a successful save closes
/// The controller comes from the matching form binding.
class MedicationFormView extends GetView<MedicationFormController> {
  const MedicationFormView({super.key});

  void _openDeleteSheet() {
    AppBottomSheet.show<void>(
      child: ConfirmSheetContent(
        title: AppStrings.medsDeleteTitle.trParams(<String, String>{
          'name': controller.form.nameController.text.trim(),
        }),
        message: AppStrings.medsDeleteMessage.trParams(<String, String>{
          'profile': controller.profile.value?.name ?? '',
        }),
        confirmLabel: AppStrings.medsDeleteAction.tr,
        cancelLabel: AppStrings.medsDeleteKeep.tr,
        icon: Icons.delete_rounded,
        onConfirm: controller.delete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      padding: EdgeInsets.zero,
      overlays: <Widget>[
        Obx(
          () => controller.isLoadingForm.value
              ? const SizedBox.shrink()
              : StickyCta(
                  child: GradientButton(
                    label: controller.isEditing
                        ? AppStrings.medsSaveChanges.tr
                        : AppStrings.medsSave.tr,
                    icon: Icons.check_circle_rounded,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.submit,
                  ),
                ),
        ),
      ],
      body: Obx(() {
        final String title = controller.isEditing
            ? AppStrings.medsEditTitle.tr
            : AppStrings.medsAddTitle.tr;
        if (controller.isLoadingForm.value) {
          return CustomScrollView(
            slivers: <Widget>[
              AppInnerHeader(title: title),
              const SliverFillRemaining(child: LoadingState()),
            ],
          );
        }
        return Form(
          key: controller.formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              AppInnerHeader(title: title),
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSizes.screenPaddingHorizontal,
                  0,
                  AppSizes.screenPaddingHorizontal,
                  StickyCta.clearance,
                ),
                sliver: SliverList.list(
                  children: <Widget>[
                    Obx(() {
                      if (controller.profile.value == null) {
                        return const SizedBox.shrink();
                      }
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          MedicationRecipientRow(),
                          SizedBox(height: AppSizes.spaceMd),
                        ],
                      );
                    }),
                    const MedicationNameDoseCard(),
                    const SizedBox(height: AppSizes.gutter),
                    const MedicationScheduleSection(),
                    const SizedBox(height: AppSizes.gutter),
                    const MedicationOptionsSection(),
                    if (controller.isEditing) ...<Widget>[
                      const SizedBox(height: AppSizes.spaceMd),
                      OutlinedActionButton(
                        label: AppStrings.medsDeleteAction.tr,
                        icon: Icons.delete_rounded,
                        tone: ActionTone.dangerText,
                        onPressed: _openDeleteSheet,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
