import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/reports/data/models/doctor_report.dart';
import 'package:dose_tracker/features/reports/presentation/report_rate.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One medication of the report: its name, dose and meal instruction, an
/// adherence badge, and the prescribed, taken and missed figures.
///
/// The badge carries the percentage as text and an icon, so the rating never
/// relies on color alone. "Missed" counts doses that were missed or skipped.
class ReportLineCard extends StatelessWidget {
  const ReportLineCard({required this.line, super.key});

  final MedicationReportLine line;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double rate = line.rate ?? 0;
    final MealInstruction? meal = line.mealInstruction;
    final BadgeTone tone = ReportRate.toneOf(rate);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${line.medicationName} '
                      '${DoseFormatter.quantity(line.doseAmount)} '
                      '${line.doseUnit.labelKey.tr}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    if (meal != null)
                      Text(meal.labelKey.tr, style: textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.spaceSm),
              StatusBadge(
                label: AppStrings.reportAdherenceBadge.trParams(
                  <String, String>{'percent': DoseFormatter.percent(rate)},
                ),
                tone: tone,
                icon: switch (tone) {
                  BadgeTone.success => Icons.check_circle_outline_rounded,
                  BadgeTone.warning => Icons.error_outline_rounded,
                  BadgeTone.danger ||
                  BadgeTone.active => Icons.warning_amber_rounded,
                },
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMd),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.appBackground,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spaceMd),
              child: Row(
                children: <Widget>[
                  _Figure(
                    label: AppStrings.reportColumnPrescribed.tr,
                    value: line.prescribed,
                    color: colors.textPrimary,
                  ),
                  _Figure(
                    label: AppStrings.reportColumnTaken.tr,
                    value: line.takenTotal,
                    color: colors.success,
                  ),
                  _Figure(
                    label: AppStrings.reportColumnMissed.tr,
                    value: line.notTaken,
                    color: line.notTaken == 0
                        ? colors.textSecondary
                        : colors.danger,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(label, style: textTheme.bodyMedium),
            Text(
              DoseFormatter.quantity(value.toDouble()),
              style: textTheme.titleLarge?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
