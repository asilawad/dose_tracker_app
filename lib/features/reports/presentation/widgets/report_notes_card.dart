import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/reports/controllers/report_controller.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The optional note to the doctor, a multi-line field. What the user types
/// is added to the PDF under the adherence figures.
///
/// The text lives in the [ReportController], so it is kept while the user
/// changes the profile or the range.
class ReportNotesCard extends GetView<ReportController> {
  const ReportNotesCard({super.key});

  static const int _minLines = 3;
  static const int _maxLines = 6;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: AppTextField(
        label: AppStrings.reportNotesTitle.tr,
        hint: AppStrings.reportNotesHint.tr,
        controller: controller.notesController,
        prefixIcon: Icons.edit_note_rounded,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        minLines: _minLines,
        maxLines: _maxLines,
      ),
    );
  }
}
