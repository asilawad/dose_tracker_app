import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Content of an "are you sure?" bottom sheet: a message, a danger confirm
/// button and a Cancel button. Open it with `AppBottomSheet.show`.
///
/// Confirming closes the sheet first, then calls [onConfirm], so any screen
/// change made by [onConfirm] happens after the sheet is gone. [message] and
/// [confirmLabel] must already be translated.
class ConfirmSheetContent extends StatelessWidget {
  const ConfirmSheetContent({
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.icon,
    super.key,
  });

  final String message;
  final String confirmLabel;
  final VoidCallback onConfirm;
  final IconData? icon;

  void _confirm() {
    Get.back<void>();
    onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(message, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: AppSizes.space2xl),
        OutlinedActionButton(
          label: confirmLabel,
          icon: icon,
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
