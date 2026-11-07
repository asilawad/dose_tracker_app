import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/schedule_grouper.dart'
    as schedule_data;
import 'package:dose_tracker/features/schedule/presentation/widgets/schedule_time_group.dart';
import 'package:flutter/material.dart';

class ScheduleDoseList extends StatelessWidget {
  const ScheduleDoseList({
    required this.doses,
    required this.onCheck,
    required this.onUndo,
    required this.onSkip,
    required this.isJustChecked,
    this.onConfirmAll,
    super.key,
  });

  final List<ScheduledDose> doses;
  final ValueChanged<ScheduledDose> onCheck;
  final ValueChanged<ScheduledDose> onUndo;
  final ValueChanged<ScheduledDose> onSkip;
  final bool Function(ScheduledDose) isJustChecked;
  final ValueChanged<List<ScheduledDose>>? onConfirmAll;

  @override
  Widget build(BuildContext context) {
    final List<schedule_data.ScheduleTimeGroup> groups =
        schedule_data.ScheduleGrouper.group(doses);
    final int nextIndex = groups.indexWhere(
      (schedule_data.ScheduleTimeGroup group) => group.profiles.any(
        (schedule_data.ScheduleProfileGroup profile) => profile.doses.any(
          (ScheduledDose dose) =>
              dose.state == DoseState.pending && !dose.isDue,
        ),
      ),
    );
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.screenPaddingHorizontal,
        0,
        AppSizes.screenPaddingHorizontal,
        AppSizes.space3xl + AppSizes.bottomOverlayClearance,
      ),
      sliver: SliverList.separated(
        itemCount: groups.length,
        separatorBuilder: (_, _) => const SizedBox(height: 18),
        itemBuilder: (BuildContext context, int index) => ScheduleTimeGroup(
          isNext: index == nextIndex,
          key: ValueKey<int>(groups[index].minuteOfDay),
          group: groups[index],
          onCheck: onCheck,
          onUndo: onUndo,
          onSkip: onSkip,
          isJustChecked: isJustChecked,
          onConfirmAll: onConfirmAll,
        ),
      ),
    );
  }
}
