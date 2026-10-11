import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/services/reminder_service.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/notifications/data/models/reminder_settings.dart';
import 'package:dose_tracker/features/settings/controllers/settings_controller.dart';
import 'package:dose_tracker/views/widgets/app_choice_chip.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The form inside the notifications bottom sheet: a switch for dose
/// reminders, how often a reminder repeats while the dose is not recorded,
/// and the notification permission status.
///
/// The repeat options show only while reminders are on. The permission part
/// shows only on devices that can show reminders, and offers an Allow button
/// when the permission is missing. Changes apply at once and are saved by
/// the controller, which comes from `SettingsBinding`.
class NotificationSettingsSheetContent extends GetView<SettingsController> {
  const NotificationSettingsSheetContent({super.key});

  static String _escalationKey(ReminderEscalation option) {
    return switch (option) {
      ReminderEscalation.off => AppStrings.notifRepeatOff,
      ReminderEscalation.everyThirtyMinutes =>
        AppStrings.notifRepeatThirtyMinutes,
      ReminderEscalation.everyHour => AppStrings.notifRepeatHour,
      ReminderEscalation.everyTwoHours => AppStrings.notifRepeatTwoHours,
    };
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final ReminderSettings settings = controller.reminderSettings.value;
      final ReminderPermission permission = controller.permission.value;
      final bool isGranted = permission == ReminderPermission.granted;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.notifEnableLabel.tr,
                      style: textTheme.titleMedium,
                    ),
                    Text(
                      AppStrings.notifEnableSubtitle.tr,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Semantics(
                label: AppStrings.notifEnableLabel.tr,
                child: Switch(
                  value: settings.enabled,
                  onChanged: (bool value) =>
                      controller.setRemindersEnabled(enabled: value),
                  activeTrackColor: colors.active,
                  activeThumbColor: colors.onActive,
                ),
              ),
            ],
          ),
          if (settings.enabled) ...<Widget>[
            const SizedBox(height: AppSizes.space2xl),
            Text(AppStrings.notifRepeatTitle.tr, style: textTheme.titleMedium),
            const SizedBox(height: AppSizes.spaceMd),
            Wrap(
              spacing: AppSizes.spaceSm,
              runSpacing: AppSizes.spaceSm,
              children: <Widget>[
                for (final ReminderEscalation option
                    in ReminderEscalation.values)
                  AppChoiceChip(
                    label: _escalationKey(option).tr,
                    selected: option == settings.escalation,
                    showCheck: true,
                    onTap: () => controller.setEscalation(option),
                  ),
              ],
            ),
          ],
          if (permission != ReminderPermission.unsupported) ...<Widget>[
            const SizedBox(height: AppSizes.space2xl),
            Row(
              children: <Widget>[
                Icon(
                  isGranted
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_off_outlined,
                  size: AppSizes.iconLg,
                  color: isGranted ? colors.success : colors.danger,
                ),
                const SizedBox(width: AppSizes.spaceMd),
                Expanded(
                  child: Text(
                    isGranted
                        ? AppStrings.notifPermissionGranted.tr
                        : AppStrings.notifPermissionDenied.tr,
                    style: textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            if (!isGranted) ...<Widget>[
              const SizedBox(height: AppSizes.spaceMd),
              OutlinedActionButton(
                label: AppStrings.notifPermissionAllow.tr,
                icon: Icons.notifications_outlined,
                onPressed: controller.requestPermission,
              ),
            ],
          ],
        ],
      );
    });
  }
}
