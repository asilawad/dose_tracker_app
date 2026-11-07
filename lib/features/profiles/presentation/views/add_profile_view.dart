import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/profiles/controllers/add_profile_controller.dart';
import 'package:dose_tracker/features/profiles/presentation/widgets/add_profile_form.dart';
import 'package:dose_tracker/views/widgets/app_inner_header.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:dose_tracker/views/widgets/sticky_cta.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Add Profile screen: back arrow, title and the form card.
///
/// It is opened on top of the main shell, so the back arrow (mirrored in
/// RTL) returns there, and a successful save closes it. The controller
/// comes from `AddProfileBinding`.
class AddProfileView extends GetView<AddProfileController> {
  const AddProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      padding: EdgeInsets.zero,
      overlays: <Widget>[
        StickyCta(
          child: Obx(
            () => GradientButton(
              label: AppStrings.actionSave.tr,
              isLoading: controller.isLoading.value,
              onPressed: controller.submit,
            ),
          ),
        ),
      ],
      body: CustomScrollView(
        slivers: <Widget>[
          AppInnerHeader(title: AppStrings.profilesAddTitle.tr),
          const SliverPadding(
            padding: EdgeInsetsDirectional.fromSTEB(
              AppSizes.screenPaddingHorizontal,
              0,
              AppSizes.screenPaddingHorizontal,
              StickyCta.clearance,
            ),
            sliver: SliverToBoxAdapter(child: AddProfileForm()),
          ),
        ],
      ),
    );
  }
}
