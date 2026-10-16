import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/reports/controllers/report_controller.dart';
import 'package:dose_tracker/features/reports/data/models/doctor_report.dart';
import 'package:dose_tracker/features/reports/presentation/widgets/report_interval_card.dart';
import 'package:dose_tracker/features/reports/presentation/widgets/report_line_card.dart';
import 'package:dose_tracker/features/reports/presentation/widgets/report_medication_filter_card.dart';
import 'package:dose_tracker/features/reports/presentation/widgets/report_missed_card.dart';
import 'package:dose_tracker/features/reports/presentation/widgets/report_notes_card.dart';
import 'package:dose_tracker/features/reports/presentation/widgets/report_overview_card.dart';
import 'package:dose_tracker/shared/widgets/profile_chips.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/empty_state.dart';
import 'package:dose_tracker/views/widgets/error_state.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:dose_tracker/views/widgets/loading_state.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Doctor's Report screen: back arrow, title, the family member chips,
/// the interval and medication filter cards, a live preview of the report
/// (overview, one card per medication, doses not taken), the optional note
/// and the Generate PDF button.
///
/// It shows a spinner while loading, an error with retry, and an empty state
/// when there are no profiles. When the chosen profile has no due doses in
/// the range it says so instead of the preview, and the Generate button is
/// hidden. The controller comes from `ReportBinding`.
class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

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
          AppStrings.reportTitle.tr,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingState();
        }
        if (controller.hasError.value) {
          return ErrorState(onRetry: controller.retry);
        }
        if (controller.profiles.isEmpty) {
          return EmptyState(
            icon: Icons.description_outlined,
            title: AppStrings.calendarEmptyTitle.tr,
            message: AppStrings.calendarEmptyMessage.tr,
          );
        }

        final DoctorReport? report = controller.report;
        final bool hasData = report != null && !report.isEmpty;

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceLg),
          children: <Widget>[
            ProfileChips(
              profiles: controller.profiles.toList(),
              selectedId: controller.selectedProfileId.value,
              onSelect: controller.selectProfile,
            ),
            const SizedBox(height: AppSizes.gutter),
            const ReportIntervalCard(),
            const SizedBox(height: AppSizes.gutter),
            const ReportMedicationFilterCard(),
            const SizedBox(height: AppSizes.gutter),
            if (!hasData)
              _EmptyRange(
                title: AppStrings.reportEmptyTitle.tr,
                message: AppStrings.reportEmptyMessage.tr,
              )
            else ...<Widget>[
              ReportOverviewCard(report: report),
              const SizedBox(height: AppSizes.space2xl),
              Text(
                AppStrings.reportDetailsTitle.tr,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSizes.spaceMd),
              for (final MedicationReportLine line in report.lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.gutter),
                  child: ReportLineCard(line: line),
                ),
              const SizedBox(height: AppSizes.spaceSm),
              ReportMissedCard(entries: report.missed),
              const SizedBox(height: AppSizes.gutter),
              const ReportNotesCard(),
              const SizedBox(height: AppSizes.space2xl),
              Obx(
                () => GradientButton(
                  label: AppStrings.reportGenerate.tr,
                  icon: Icons.picture_as_pdf_outlined,
                  isLoading: controller.isGenerating.value,
                  onPressed: controller.generate,
                ),
              ),
            ],
            const SizedBox(height: AppSizes.space2xl),
          ],
        );
      }),
    );
  }
}

class _EmptyRange extends StatelessWidget {
  const _EmptyRange({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: textTheme.titleMedium),
          const SizedBox(height: AppSizes.spaceXs),
          Text(message, style: textTheme.bodyMedium),
        ],
      ),
    );
  }
}
