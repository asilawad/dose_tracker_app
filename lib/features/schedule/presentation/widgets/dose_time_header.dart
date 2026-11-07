import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Header above each time slot (design `.slot-h`): the time, a "Next" pill
/// for the upcoming slot, and a status at the end edge.
class DoseTimeHeader extends StatelessWidget {
  const DoseTimeHeader({
    required this.minuteOfDay,
    this.doses = const <ScheduledDose>[],
    this.isNext = false,
    super.key,
  });

  final int minuteOfDay;
  final List<ScheduledDose> doses;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme text = Theme.of(context).textTheme;
    final int missed = doses
        .where((ScheduledDose d) => d.state == DoseState.missed)
        .length;
    final bool allTaken =
        doses.isNotEmpty &&
        doses.every(
          (ScheduledDose d) =>
              d.state == DoseState.taken || d.state == DoseState.takenLate,
        );

    final (IconData?, String, Color) status = allTaken
        ? (
            Icons.check_circle_rounded,
            AppStrings.scheduleSlotAllTaken.tr,
            colors.success,
          )
        : missed > 0
        ? (
            Icons.error_rounded,
            AppStrings.scheduleSlotMissed.trParams(<String, String>{
              'count': '$missed',
            }),
            colors.danger,
          )
        : (
            null,
            doses.length == 1
                ? AppStrings.scheduleSlotOneDose.tr
                : AppStrings.scheduleSlotDoses.trParams(<String, String>{
                    'count': '${doses.length}',
                  }),
            colors.textTertiary,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceXs),
      child: Row(
        children: <Widget>[
          Text(
            DoseFormatter.minuteOfDay(minuteOfDay),
            style: text.titleMedium?.copyWith(fontSize: 15),
          ),
          if (isNext) ...<Widget>[
            const SizedBox(width: AppSizes.spaceSm),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.active,
                borderRadius: BorderRadius.circular(AppSizes.radiusChip),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text(
                  AppStrings.scheduleSlotNext.tr,
                  style: text.labelMedium?.copyWith(color: colors.onActive),
                ),
              ),
            ),
          ],
          const Spacer(),
          if (doses.isNotEmpty) ...<Widget>[
            if (status.$1 != null) ...<Widget>[
              Icon(status.$1, size: AppSizes.iconSm, color: status.$3),
              const SizedBox(width: AppSizes.spaceXs),
            ],
            Text(status.$2, style: text.bodySmall?.copyWith(color: status.$3)),
          ],
        ],
      ),
    );
  }
}
