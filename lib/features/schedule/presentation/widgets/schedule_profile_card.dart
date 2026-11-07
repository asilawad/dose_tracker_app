import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/schedule_grouper.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/dose_tile.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleProfileCard extends StatelessWidget {
  const ScheduleProfileCard({
    required this.group,
    required this.onCheck,
    required this.onUndo,
    this.onSkip,
    required this.isJustChecked,
    this.onConfirmAll,
    this.showProfile = true,
    super.key,
  });

  final ScheduleProfileGroup group;
  final ValueChanged<ScheduledDose> onCheck;
  final ValueChanged<ScheduledDose> onUndo;
  final ValueChanged<ScheduledDose>? onSkip;
  final bool Function(ScheduledDose) isJustChecked;
  final ValueChanged<List<ScheduledDose>>? onConfirmAll;
  final bool showProfile;

  bool _canCheck(ScheduledDose dose) => dose.canRecord;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final int confirmableCount = group.doses.where(_canCheck).length;
    final Widget card = AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
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
              showProfile: showProfile,
              isTaken:
                  group.doses[index].state == DoseState.taken ||
                  group.doses[index].state == DoseState.takenLate ||
                  isJustChecked(group.doses[index]),
              isJustChecked: isJustChecked(group.doses[index]),
              onToggle: isJustChecked(group.doses[index])
                  ? () => onUndo(group.doses[index])
                  : group.doses[index].canRecord
                  ? () => onCheck(group.doses[index])
                  : null,
              onSkip: onSkip == null || !group.doses[index].canRecord
                  ? null
                  : () => onSkip!(group.doses[index]),
            ),
          ],
          if (showProfile &&
              onConfirmAll != null &&
              confirmableCount >= 2) ...<Widget>[
            Divider(
              height: AppSizes.borderHairline,
              thickness: AppSizes.borderHairline,
              color: colors.borderHairline,
            ),
            TextButton.icon(
              onPressed: () => onConfirmAll!(group.doses),
              icon: const Icon(Icons.done_all_rounded, size: AppSizes.iconMd),
              label: Text(AppStrings.scheduleConfirmAll.tr),
              style: TextButton.styleFrom(
                foregroundColor: colors.activeDeep,
                minimumSize: const Size.fromHeight(AppSizes.minTapTarget),
              ),
            ),
          ],
        ],
      ),
    );
    return showProfile
        ? Semantics(label: group.profileName, child: card)
        : card;
  }
}
