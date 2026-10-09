import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/settings/controllers/settings_controller.dart';
import 'package:dose_tracker/features/settings/presentation/widgets/language_sheet_content.dart';
import 'package:dose_tracker/features/settings/presentation/widgets/settings_row.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Settings tab: language (opens a bottom sheet), the Appearance row
/// (visible but disabled for now) and Log Out.
///
/// It is a body only; the main shell owns the scaffold. Calendar and
/// Report rows are added with those screens. The controller comes from
/// `SettingsBinding`.
class SettingsTabView extends GetView<SettingsController> {
  const SettingsTabView({super.key});

  void _openLanguageSheet() {
    AppBottomSheet.show<void>(
      title: AppStrings.settingsLanguage.tr,
      child: const LanguageSheetContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.screenPaddingHorizontal,
        vertical: AppSizes.space2xl,
      ),
      children: <Widget>[
        Text(
          AppStrings.navSettings.tr,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSizes.space2xl),
        Obx(
          () => SettingsRow(
            icon: Icons.language_rounded,
            title: AppStrings.settingsLanguage.tr,
            value: controller.languageName(controller.currentLocale.value),
            onTap: _openLanguageSheet,
          ),
        ),
        const SizedBox(height: AppSizes.gutter),
        SettingsRow(
          icon: Icons.palette_outlined,
          title: AppStrings.settingsAppearance.tr,
          value: AppStrings.settingsComingSoon.tr,
        ),
        const SizedBox(height: AppSizes.space2xl),
        OutlinedActionButton(
          label: AppStrings.settingsLogOut.tr,
          icon: Icons.logout_rounded,
          tone: ActionTone.danger,
          onPressed: controller.logOut,
        ),
      ],
    );
  }
}
