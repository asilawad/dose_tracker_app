import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/schedule_grouper.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/dose_tile.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleProfileCard extends StatelessWidget {
  const ScheduleProfileCard({
    required this.group,
    required this.onCheck,
    required this.onUndo,
    required this.onSkip,
    required this.isJustChecked,
    required this.canConfirmAll,
    super.key,
  });

  final ScheduleProfileGroup group;
  final ValueChanged<ScheduledDose> onCheck;
  final ValueChanged<ScheduledDose> onUndo;
  final ValueChanged<ScheduledDose> onSkip;
  final bool Function(ScheduledDose) isJustChecked;
  final bool canConfirmAll;

  bool _canCheck(ScheduledDose dose) =>
      dose.state == DoseState.pending || dose.state == DoseState.missed;

  void _confirmAll() {
    for (final ScheduledDose dose in group.doses) {
      if (_canCheck(dose) && !isJustChecked(dose)) {
        onCheck(dose);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final int confirmableCount = group.doses.where(_canCheck).length;
    return Semantics(
      label: group.profileName,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                PersonaAvatar(
                  persona: group.personaColor,
                  size: PersonaAvatarSize.small,
                  avatar: group.profileAvatar,
                  name: group.profileName,
                ),
                const SizedBox(width: AppSizes.spaceMd),
                Expanded(
                  child: Text(
                    group.profileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (canConfirmAll && confirmableCount >= 2)
                  TextButton(
                    onPressed: _confirmAll,
                    child: Text(AppStrings.scheduleConfirmAll.tr),
                  ),
              ],
            ),
            Divider(
              height: AppSizes.spaceLg,
              thickness: AppSizes.borderHairline,
              color: colors.borderHairline,
            ),
            for (int index = 0; index < group.doses.length; index++) ...<Widget>[
              if (index > 0)
                Divider(
                  height: AppSizes.borderHairline,
                  thickness: AppSizes.borderHairline,
                  color: colors.borderHairline,
                ),
              DoseTile(
                key: ValueKey<String>(group.doses[index].key),
                dose: group.doses[index],
                isTaken:
                    group.doses[index].state == DoseState.taken ||
                    group.doses[index].state == DoseState.takenLate ||
                    isJustChecked(group.doses[index]),
                onToggle: () =>
                    group.doses[index].state == DoseState.taken ||
                        group.doses[index].state == DoseState.takenLate ||
                        isJustChecked(group.doses[index])
                    ? onUndo(group.doses[index])
                    : onCheck(group.doses[index]),
                onSkip: () => onSkip(group.doses[index]),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
