import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/reports/data/models/doctor_report.dart';
import 'package:dose_tracker/features/reports/presentation/report_rate.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/stock_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The adherence overview card of the report: the overall percentage with a
/// progress bar, how many due doses were taken, and two figures for doses
/// not taken and doses taken late.
///
/// Screen readers read the percentage and the summary line as text; the bar
/// is decoration only.
class ReportOverviewCard extends StatelessWidget {
  const ReportOverviewCard({required this.report, super.key});

  final DoctorReport report;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double rate = report.rate ?? 0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.reportOverviewTitle.tr,
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSizes.spaceXs),
                    Text(
                      AppStrings.reportOverviewSummary
                          .trParams(<String, String>{
                            'taken': DoseFormatter.quantity(
                              report.takenTotal.toDouble(),
                            ),
                            'total': DoseFormatter.quantity(
                              report.prescribed.toDouble(),
                            ),
                          }),
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.spaceMd),
              Text(
                DoseFormatter.percent(rate),
                style: textTheme.headlineLarge?.copyWith(
                  color: ReportRate.colorOf(rate, colors),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spaceMd),
          StockProgressBar(fraction: rate, isLow: ReportRate.isPoor(rate)),
          const SizedBox(height: AppSizes.spaceLg),
          Row(
            children: <Widget>[
              Expanded(
                child: _StatTile(
                  count: report.notTaken,
                  label: AppStrings.reportStatMissed.tr,
                  background: colors.dangerTint,
                  foreground: colors.danger,
                  icon: Icons.close_rounded,
                ),
              ),
              const SizedBox(width: AppSizes.spaceMd),
              Expanded(
                child: _StatTile(
                  count: report.takenLate,
                  label: AppStrings.reportStatLate.tr,
                  background: colors.warningTint,
                  foreground: colors.textPrimary,
                  icon: Icons.schedule_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.count,
    required this.label,
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final int count;
  final String label;
  final Color background;
  final Color foreground;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spaceMd),
          child: Row(
            children: <Widget>[
              Icon(icon, size: AppSizes.iconLg, color: foreground),
              const SizedBox(width: AppSizes.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DoseFormatter.quantity(count.toDouble()),
                      style: textTheme.titleLarge?.copyWith(color: foreground),
                    ),
                    Text(label, style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
