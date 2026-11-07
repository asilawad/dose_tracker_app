import 'dart:async';

import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/settings/controllers/settings_controller.dart';
import 'package:dose_tracker/features/settings/presentation/widgets/language_sheet_content.dart';
import 'package:dose_tracker/features/settings/presentation/widgets/notification_settings_sheet_content.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/app_collapsing_header.dart';
import 'package:dose_tracker/views/widgets/app_list_row.dart';
import 'package:dose_tracker/views/widgets/confirm_sheet_content.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Settings tab: notifications and language (each opens a bottom
/// sheet), the Appearance row (visible but disabled for now) and Log Out.
///
/// It is a body only; the main shell owns the scaffold. The controller comes from
/// `SettingsBinding`.
class SettingsTabView extends GetView<SettingsController> {
  const SettingsTabView({super.key});

  void _openLanguageSheet() {
    AppBottomSheet.show<void>(
      title: AppStrings.settingsLanguage.tr,
      subtitle: AppStrings.settingsLanguageSubtitle.tr,
      child: const LanguageSheetContent(),
    );
  }

  void _openNotificationsSheet() {
    unawaited(controller.refreshPermission());
    AppBottomSheet.show<void>(
      title: AppStrings.notifSheetTitle.tr,
      child: const NotificationSettingsSheetContent(),
    );
  }

  void _openLogOutSheet() {
    AppBottomSheet.show<void>(
      child: ConfirmSheetContent(
        title: AppStrings.settingsLogOutTitle.tr,
        message: AppStrings.settingsLogOutMessage.tr,
        confirmLabel: AppStrings.settingsLogOut.tr,
        icon: Icons.logout_rounded,
        onConfirm: controller.logOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return CustomScrollView(
      slivers: <Widget>[
        AppCollapsingHeader(title: AppStrings.navSettings.tr),
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSizes.screenPaddingHorizontal,
            AppSizes.spaceSm,
            AppSizes.screenPaddingHorizontal,
            AppSizes.space2xl + AppSizes.bottomOverlayClearance,
          ),
          sliver: SliverList.list(
            children: <Widget>[
              AppListGroup(
                children: <Widget>[
                  Obx(
                    () => AppListRow(
                      icon: Icons.notifications_rounded,
                      title: AppStrings.notifSettingsRowTitle.tr,
                      value: controller.reminderSettings.value.enabled
                          ? AppStrings.notifStateOn.tr
                          : AppStrings.notifStateOff.tr,
                      onTap: _openNotificationsSheet,
                    ),
                  ),
                  Obx(
                    () => AppListRow(
                      icon: Icons.language_rounded,
                      title: AppStrings.settingsLanguage.tr,
                      value: controller.languageName(
                        controller.currentLocale.value,
                      ),
                      onTap: _openLanguageSheet,
                    ),
                  ),
                  AppListRow(
                    icon: Icons.palette_rounded,
                    title: AppStrings.settingsAppearance.tr,
                    value: AppStrings.settingsComingSoon.tr,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.gutter),
              AppListGroup(
                children: <Widget>[
                  AppListRow(
                    icon: Icons.description_rounded,
                    title: AppStrings.reportSettingsRowTitle.tr,
                    subtitle: AppStrings.reportSettingsRowSubtitle.tr,
                    iconColor: colors.personaBlue,
                    iconBackground: colors.personaBlueTint,
                    onTap: controller.openReport,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              OutlinedActionButton(
                label: AppStrings.settingsLogOut.tr,
                icon: Icons.logout_rounded,
                tone: ActionTone.danger,
                onPressed: _openLogOutSheet,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
