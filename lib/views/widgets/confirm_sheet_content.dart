import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Content of an "are you sure?" bottom sheet: danger badge, centered title
/// and message, a solid danger button and a quiet way out. Open it with
/// `AppBottomSheet.show` without a sheet title.
///
/// Confirming closes the sheet first, then calls [onConfirm], so any screen
/// change made by [onConfirm] happens after the sheet is gone. All text must
/// already be translated; [cancelLabel] defaults to Cancel.
class ConfirmSheetContent extends StatelessWidget {
  const ConfirmSheetContent({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel,
    this.icon,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String? cancelLabel;
  final VoidCallback onConfirm;
  final IconData? icon;

  void _confirm() {
    Get.back<void>();
    onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Center(
            child: Container(
              width: AppSizes.dangerBadgeSize,
              height: AppSizes.dangerBadgeSize,
              decoration: BoxDecoration(
                color: colors.dangerTint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppSizes.dangerBadgeIcon,
                color: colors.danger,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spaceMd),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSizes.spaceXs),
        Text(message, textAlign: TextAlign.center, style: textTheme.bodyMedium),
        const SizedBox(height: AppSizes.spaceLg),
        OutlinedActionButton(
          label: confirmLabel,
          tone: ActionTone.dangerSolid,
          onPressed: _confirm,
        ),
        const SizedBox(height: AppSizes.spaceSm),
        OutlinedActionButton(
          label: cancelLabel ?? AppStrings.actionCancel.tr,
          tone: ActionTone.plain,
          onPressed: () => Get.back<void>(),
        ),
      ],
    );
  }
}
