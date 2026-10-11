import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:dose_tracker/features/reports/controllers/report_controller.dart';
import 'package:dose_tracker/features/reports/data/models/report_range.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_choice_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The report interval card: the three range choices (last 7 days, last 30
/// days, custom) and the dates of the chosen range.
///
/// Choosing "custom" opens the system date range picker, which allows days
/// up to today and up to [_maxYearsBack] years back. State comes from
/// [ReportController].
class ReportIntervalCard extends GetView<ReportController> {
  const ReportIntervalCard({super.key});

  static const int _maxYearsBack = 5;

  static String _labelKey(ReportInterval value) {
    return switch (value) {
      ReportInterval.last7Days => AppStrings.reportLast7,
      ReportInterval.last30Days => AppStrings.reportLast30,
      ReportInterval.custom => AppStrings.reportCustom,
    };
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final DateTime today = DosePlanner.dayStart(DateTime.now());
    final ReportRange current = controller.range;
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(today.year - _maxYearsBack),
      lastDate: today,
      initialDateRange: DateTimeRange(start: current.from, end: current.to),
    );
    if (picked != null) {
      controller.setCustomRange(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Obx(() {
        final ReportRange range = controller.range;
        final ReportInterval selected = controller.interval.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              AppStrings.reportIntervalTitle.tr,
              style: textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSizes.spaceXs),
            Text(
              AppStrings.reportRangeValue.trParams(<String, String>{
                'from': DateFormatter.dayMonthYear(range.from),
                'to': DateFormatter.dayMonthYear(range.to),
              }),
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSizes.spaceMd),
            Wrap(
              spacing: AppSizes.spaceSm,
              runSpacing: AppSizes.spaceSm,
              children: <Widget>[
                for (final ReportInterval option in ReportInterval.values)
                  AppChoiceChip(
                    label: _labelKey(option).tr,
                    selected: option == selected,
                    showCheck: true,
                    onTap: () => option == ReportInterval.custom
                        ? _pickCustomRange(context)
                        : controller.selectInterval(option),
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
