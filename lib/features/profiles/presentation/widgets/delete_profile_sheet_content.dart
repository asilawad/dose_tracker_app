import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/profiles/controllers/edit_profile_controller.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The content of the "delete this profile?" bottom sheet: what will be
/// deleted, a danger Delete button and a Cancel button.
///
/// Confirming closes this sheet first, then deletes, which also closes the
/// Edit Profile screen. The controller comes from `EditProfileBinding`.
class DeleteProfileSheetContent extends GetView<EditProfileController> {
  const DeleteProfileSheetContent({super.key});

  void _confirm() {
    Get.back<void>();
    controller.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Obx(
          () => Text(
            AppStrings.profilesDeleteMessage.trParams(<String, String>{
              'name': controller.savedName.value,
            }),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: AppSizes.space2xl),
        OutlinedActionButton(
          label: AppStrings.actionDelete.tr,
          icon: Icons.delete_outline_rounded,
          tone: ActionTone.danger,
          onPressed: _confirm,
        ),
        const SizedBox(height: AppSizes.spaceMd),
        OutlinedActionButton(
          label: AppStrings.actionCancel.tr,
          onPressed: () => Get.back<void>(),
        ),
      ],
    );
  }
}
