import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/schedule_grouper.dart'
    as schedule_data;
import 'package:dose_tracker/features/schedule/presentation/widgets/dose_time_header.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/schedule_profile_card.dart';
import 'package:flutter/material.dart';

class ScheduleTimeGroup extends StatelessWidget {
  const ScheduleTimeGroup({
    required this.group,
    required this.onCheck,
    required this.onUndo,
    this.onSkip,
    required this.isJustChecked,
    this.onConfirmAll,
    this.showProfile = true,
    this.isNext = false,
    super.key,
  });

  final schedule_data.ScheduleTimeGroup group;
  final ValueChanged<ScheduledDose> onCheck;
  final ValueChanged<ScheduledDose> onUndo;
  final ValueChanged<ScheduledDose>? onSkip;
  final bool Function(ScheduledDose) isJustChecked;
  final ValueChanged<List<ScheduledDose>>? onConfirmAll;
  final bool showProfile;

  /// Marks this slot as the next one due.
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: AppDurations.normal,
      curve: AppDurations.standardCurve,
      alignment: AlignmentDirectional.topStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DoseTimeHeader(
            minuteOfDay: group.minuteOfDay,
            isNext: isNext,
            doses: <ScheduledDose>[
              for (final schedule_data.ScheduleProfileGroup profile
                  in group.profiles)
                ...profile.doses,
            ],
          ),
          const SizedBox(height: AppSizes.spaceSm),
          for (
            int index = 0;
            index < group.profiles.length;
            index++
          ) ...<Widget>[
            if (index > 0) const SizedBox(height: AppSizes.gutter),
            ScheduleProfileCard(
              key: ValueKey<int>(group.profiles[index].profileId),
              group: group.profiles[index],
              onCheck: onCheck,
              onUndo: onUndo,
              onSkip: onSkip,
              isJustChecked: isJustChecked,
              onConfirmAll: onConfirmAll,
              showProfile: showProfile,
            ),
          ],
        ],
      ),
    );
  }
}
