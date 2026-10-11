import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/date_formatter.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/reports/data/models/doctor_report.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The "doses not taken" card of the report: one row for each dose that was
/// missed or skipped, with its date and time, a labeled badge and, for a
/// skipped dose, the reason the user gave.
///
/// When there are none it says so in one line.
class ReportMissedCard extends StatelessWidget {
  const ReportMissedCard({required this.entries, super.key});

  final List<MissedDoseEntry> entries;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(AppStrings.reportMissedTitle.tr, style: textTheme.headlineSmall),
          const SizedBox(height: AppSizes.spaceMd),
          if (entries.isEmpty)
            Text(AppStrings.reportMissedNone.tr, style: textTheme.bodyMedium)
          else
            for (final MissedDoseEntry entry in entries)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spaceSm),
                child: _MissedRow(entry: entry),
              ),
        ],
      ),
    );
  }
}

class _MissedRow extends StatelessWidget {
  const _MissedRow({required this.entry});

  final MissedDoseEntry entry;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isMissed = entry.kind == MissedDoseKind.missed;
    final String? reason = entry.reason;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isMissed ? colors.dangerTint : colors.appBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${entry.medicationName} '
                    '${DoseFormatter.quantity(entry.doseAmount)} '
                    '${entry.doseUnit.labelKey.tr}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium,
                  ),
                  Wrap(
                    spacing: AppSizes.spaceSm,
                    children: <Widget>[
                      Text(
                        DateFormatter.dayMonthYear(entry.scheduledAt),
                        style: textTheme.bodyMedium,
                      ),
                      Text(
                        DateFormatter.time(entry.scheduledAt),
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  if (reason != null)
                    Text(
                      AppStrings.reportSkippedReason.trParams(<String, String>{
                        'reason': reason,
                      }),
                      style: textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.spaceSm),
            StatusBadge(
              label: isMissed
                  ? AppStrings.scheduleStateMissed.tr
                  : AppStrings.scheduleStateSkipped.tr,
              tone: isMissed ? BadgeTone.danger : BadgeTone.active,
              icon: isMissed ? Icons.close_rounded : Icons.remove_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
