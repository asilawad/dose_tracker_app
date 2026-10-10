import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The form inside the "skip this dose" bottom sheet: an optional reason
/// and the Skip and Cancel buttons.
///
/// The sheet closes first, then [onConfirm] gets the trimmed reason, or null
/// when the field was left empty.
class SkipDoseSheetContent extends StatefulWidget {
  const SkipDoseSheetContent({required this.onConfirm, super.key});

  final ValueChanged<String?> onConfirm;

  @override
  State<SkipDoseSheetContent> createState() => _SkipDoseSheetContentState();
}

class _SkipDoseSheetContentState extends State<SkipDoseSheetContent> {
  final TextEditingController _reasonController = TextEditingController();

  void _confirm() {
    final String reason = _reasonController.text.trim();
    Get.back<void>();
    widget.onConfirm(reason.isEmpty ? null : reason);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppTextField(
          label: AppStrings.scheduleSkipReasonLabel.tr,
          hint: AppStrings.scheduleSkipReasonHint.tr,
          controller: _reasonController,
          prefixIcon: Icons.notes_rounded,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _confirm(),
        ),
        const SizedBox(height: AppSizes.space2xl),
        GradientButton(label: AppStrings.actionSkip.tr, onPressed: _confirm),
        const SizedBox(height: AppSizes.spaceMd),
        OutlinedActionButton(
          label: AppStrings.actionCancel.tr,
          onPressed: () => Get.back<void>(),
        ),
      ],
    );
  }
}
