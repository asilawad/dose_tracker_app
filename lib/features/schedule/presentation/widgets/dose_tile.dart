import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoseTile extends StatelessWidget {
  const DoseTile({
    required this.dose,
    required this.onToggle,
    required this.onSkip,
    this.isTaken,
    super.key,
  });

  final ScheduledDose dose;
  final bool? isTaken;
  final VoidCallback? onToggle;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool checked =
        isTaken ??
        (dose.state == DoseState.taken || dose.state == DoseState.takenLate);
    return InkWell(
      onLongPress: onSkip,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceSm),
        child: Row(
          children: <Widget>[
            PersonaAvatar(
              persona: dose.personaColor,
              size: PersonaAvatarSize.small,
            ),
            const SizedBox(width: AppSizes.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(dose.medicationName, style: textTheme.titleMedium),
                  Text(
                    '${DoseFormatter.quantity(dose.doseAmount)} '
                    '${dose.doseUnit.labelKey.tr}',
                    style: textTheme.bodyMedium,
                  ),
                  if (dose.state == DoseState.missed) ...<Widget>[
                    const SizedBox(height: AppSizes.spaceXs),
                    Text(
                      AppStrings.scheduleStateMissed.tr,
                      style: textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            _Check(isTaken: checked, onTap: onToggle),
          ],
        ),
      ),
    );
  }
}

class _Check extends StatelessWidget {
  const _Check({required this.isTaken, required this.onTap});

  final bool isTaken;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    return Semantics(
      button: onTap != null,
      label: (isTaken ? AppStrings.a11yUndoTaken : AppStrings.a11yMarkTaken).tr,
      child: ExcludeSemantics(
        child: InkResponse(
          onTap: onTap,
          radius: AppSizes.minTapTarget / 2,
          child: SizedBox(
            width: AppSizes.minTapTarget,
            height: AppSizes.minTapTarget,
            child: Center(
              child: AnimatedContainer(
                duration: AppDurations.fast,
                curve: AppDurations.standardCurve,
                width: AppSizes.iconXl,
                height: AppSizes.iconXl,
                decoration: BoxDecoration(
                  color: isTaken ? colors.success : colors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isTaken ? colors.success : colors.borderHairline,
                    width: AppSizes.borderHairline,
                  ),
                ),
                child: isTaken
                    ? Icon(
                        Icons.check_rounded,
                        size: AppSizes.iconMd,
                        color: colors.onActive,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
