import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/dose_tile.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/dose_time_header.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:flutter/material.dart';

class ScheduleDoseList extends StatelessWidget {
  const ScheduleDoseList({
    required this.doses,
    required this.onCheck,
    required this.onUndo,
    required this.onSkip,
    required this.isJustChecked,
    super.key,
  });

  final List<ScheduledDose> doses;
  final ValueChanged<ScheduledDose> onCheck;
  final ValueChanged<ScheduledDose> onUndo;
  final ValueChanged<ScheduledDose> onSkip;
  final bool Function(ScheduledDose) isJustChecked;

  Map<int, List<ScheduledDose>> _group() {
    final Map<String, ScheduledDose> unique = <String, ScheduledDose>{
      for (final ScheduledDose dose in doses) dose.key: dose,
    };
    final Map<int, List<ScheduledDose>> groups = <int, List<ScheduledDose>>{};
    for (final ScheduledDose dose in unique.values) {
      groups.putIfAbsent(dose.minuteOfDay, () => <ScheduledDose>[]).add(dose);
    }
    return Map<int, List<ScheduledDose>>.fromEntries(
      groups.entries.toList()
        ..sort(
          (MapEntry<int, List<ScheduledDose>> a,
              MapEntry<int, List<ScheduledDose>> b) =>
              a.key.compareTo(b.key),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<int, List<ScheduledDose>>> groups =
        _group().entries.toList();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.screenPaddingHorizontal,
        0,
        AppSizes.screenPaddingHorizontal,
        AppSizes.space3xl,
      ),
      itemCount: groups.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSizes.spaceLg),
      itemBuilder: (BuildContext context, int index) => _TimeGroup(
        key: ValueKey<int>(groups[index].key),
        minuteOfDay: groups[index].key,
        doses: groups[index].value,
        onCheck: onCheck,
        onUndo: onUndo,
        onSkip: onSkip,
        isJustChecked: isJustChecked,
      ),
    );
  }
}

class _TimeGroup extends StatelessWidget {
  const _TimeGroup({
    required this.minuteOfDay,
    required this.doses,
    required this.onCheck,
    required this.onUndo,
    required this.onSkip,
    required this.isJustChecked,
    super.key,
  });

  final int minuteOfDay;
  final List<ScheduledDose> doses;
  final ValueChanged<ScheduledDose> onCheck;
  final ValueChanged<ScheduledDose> onUndo;
  final ValueChanged<ScheduledDose> onSkip;
  final bool Function(ScheduledDose) isJustChecked;

  @override
  Widget build(BuildContext context) {
    final Color divider = context.appColors.borderHairline;
    return AnimatedSize(
      duration: AppDurations.normal,
      curve: AppDurations.standardCurve,
      alignment: Alignment.topCenter,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DoseTimeHeader(minuteOfDay: minuteOfDay),
            const SizedBox(height: AppSizes.spaceSm),
            for (int index = 0; index < doses.length; index++) ...<Widget>[
              if (index > 0) Divider(height: 1, color: divider),
              DoseTile(
                key: ValueKey<String>(doses[index].key),
                dose: doses[index],
                isTaken:
                    doses[index].state == DoseState.taken ||
                    doses[index].state == DoseState.takenLate ||
                    isJustChecked(doses[index]),
                onToggle: () =>
                    doses[index].state == DoseState.taken ||
                        doses[index].state == DoseState.takenLate ||
                        isJustChecked(doses[index])
                    ? onUndo(doses[index])
                    : onCheck(doses[index]),
                onSkip: () => onSkip(doses[index]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
