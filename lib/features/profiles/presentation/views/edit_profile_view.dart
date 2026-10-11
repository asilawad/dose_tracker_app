import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/profiles/controllers/edit_profile_controller.dart';
import 'package:dose_tracker/features/profiles/presentation/widgets/delete_profile_sheet_content.dart';
import 'package:dose_tracker/features/profiles/presentation/widgets/edit_profile_form.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Edit Profile screen: back arrow, title, the form card and a Delete
/// Profile button under it that opens a confirmation sheet.
///
/// While the profile is loading it shows a spinner. It is opened on top of
/// the main shell, so the back arrow (mirrored in RTL) returns there, and a
/// successful save or delete closes it. The controller comes from
/// `EditProfileBinding`.
class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  void _openDeleteSheet() {
    AppBottomSheet.show<void>(
      title: AppStrings.profilesDeleteTitle.tr,
      child: const DeleteProfileSheetContent(),
    );
  }

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
          AppStrings.profilesEditTitle.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingProfile.value) {
          return const LoadingState();
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const EditProfileForm(),
              const SizedBox(height: AppSizes.space2xl),
              OutlinedActionButton(
                label: AppStrings.profilesDeleteAction.tr,
                icon: Icons.delete_outline_rounded,
                tone: ActionTone.danger,
                onPressed: _openDeleteSheet,
              ),
            ],
          ),
        );
      }),
    );
  }
}
