import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/profiles/controllers/edit_profile_controller.dart';
import 'package:dose_tracker/features/profiles/presentation/widgets/delete_profile_sheet_content.dart';
import 'package:dose_tracker/features/profiles/presentation/widgets/edit_profile_form.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/app_inner_header.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:dose_tracker/views/widgets/sticky_cta.dart';
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
    return ScreenScaffold(
      padding: EdgeInsets.zero,
      overlays: <Widget>[
        Obx(
          () => controller.isLoadingProfile.value
              ? const SizedBox.shrink()
              : StickyCta(
                  child: GradientButton(
                    label: AppStrings.actionSave.tr,
                    isLoading: controller.isLoading.value,
                    onPressed: controller.submit,
                  ),
                ),
        ),
      ],
      body: Obx(() {
        final Widget body = controller.isLoadingProfile.value
            ? const SliverFillRemaining(child: LoadingState())
            : SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  AppSizes.screenPaddingHorizontal,
                  0,
                  AppSizes.screenPaddingHorizontal,
                  StickyCta.clearance,
                ),
                sliver: SliverList.list(
                  children: <Widget>[
                    const EditProfileForm(),
                    const SizedBox(height: AppSizes.spaceMd),
                    OutlinedActionButton(
                      label: AppStrings.profilesDeleteAction.tr,
                      icon: Icons.delete_rounded,
                      tone: ActionTone.dangerText,
                      onPressed: _openDeleteSheet,
                    ),
                  ],
                ),
              );
        return CustomScrollView(
          slivers: <Widget>[
            AppInnerHeader(title: AppStrings.profilesEditTitle.tr),
            body,
          ],
        );
      }),
    );
  }
}
