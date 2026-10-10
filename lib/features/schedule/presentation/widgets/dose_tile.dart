import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One dose in the schedule: who it is for, the medication with its dose,
/// the amount and meal instruction, and a circle showing its state.
///
/// Tapping the circle calls [onToggle] (take the dose, or undo it when it
/// was taken). Tapping the card calls [onSkip]. Pass null to disable either,
/// for example for doses of future days. Late, skipped and missed doses also
/// show a labeled badge, so state never relies on color alone.
class DoseTile extends StatelessWidget {
  const DoseTile({
    required this.dose,
    required this.onToggle,
    required this.onSkip,
    super.key,
  });

  final ScheduledDose dose;
  final VoidCallback? onToggle;
  final VoidCallback? onSkip;

  static String _stateKey(DoseState state) {
    return switch (state) {
      DoseState.pending => AppStrings.scheduleStatePending,
      DoseState.taken => AppStrings.scheduleStateTaken,
      DoseState.takenLate => AppStrings.scheduleStateTakenLate,
      DoseState.skipped => AppStrings.scheduleStateSkipped,
      DoseState.missed => AppStrings.scheduleStateMissed,
    };
  }

  static (BadgeTone, IconData)? _badge(DoseState state) {
    return switch (state) {
      DoseState.takenLate => (BadgeTone.warning, Icons.schedule_rounded),
      DoseState.skipped => (BadgeTone.active, Icons.remove_rounded),
      DoseState.missed => (BadgeTone.danger, Icons.close_rounded),
      DoseState.pending || DoseState.taken => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final MealInstruction? meal = dose.mealInstruction;
    final (BadgeTone, IconData)? badge = _badge(dose.state);
    final String stateLabel = _stateKey(dose.state).tr;
    final String title =
        '${dose.medicationName} ${DoseFormatter.quantity(dose.doseAmount)} '
        '${dose.doseUnit.labelKey.tr}';

    return AppCard(
      onTap: onSkip,
      child: Row(
        children: <Widget>[
          PersonaAvatar(persona: dose.personaColor),
          const SizedBox(width: AppSizes.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dose.profileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: AppSizes.spaceXs),
                Wrap(
                  spacing: AppSizes.spaceSm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(
                      AppStrings.medsQuantitySummary.trParams(<String, String>{
                        'count': DoseFormatter.quantity(dose.quantity),
                      }),
                      style: textTheme.bodyMedium,
                    ),
                    if (meal != null) ...<Widget>[
                      Container(
                        width: AppSizes.spaceXs,
                        height: AppSizes.spaceXs,
                        decoration: BoxDecoration(
                          color: colors.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(meal.labelKey.tr, style: textTheme.bodyMedium),
                    ],
                  ],
                ),
                if (badge != null) ...<Widget>[
                  const SizedBox(height: AppSizes.spaceSm),
                  StatusBadge(
                    label: stateLabel,
                    tone: badge.$1,
                    icon: badge.$2,
                  ),
                ],
              ],
            ),
          ),
          _DoseCheck(
            state: dose.state,
            stateLabel: stateLabel,
            onToggle: onToggle,
          ),
        ],
      ),
    );
  }
}

class _DoseCheck extends StatelessWidget {
  const _DoseCheck({
    required this.state,
    required this.stateLabel,
    required this.onToggle,
  });

  final DoseState state;
  final String stateLabel;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final bool isTaken =
        state == DoseState.taken || state == DoseState.takenLate;

    return Semantics(
      button: onToggle != null,
      label: (isTaken ? AppStrings.a11yUndoTaken : AppStrings.a11yMarkTaken).tr,
      value: stateLabel,
      child: ExcludeSemantics(
        child: InkResponse(
          onTap: onToggle,
          radius: AppSizes.minTapTarget / 2,
          child: SizedBox(
            width: AppSizes.minTapTarget,
            height: AppSizes.minTapTarget,
            child: Center(child: _StateCircle(state: state)),
          ),
        ),
      ),
    );
  }
}

class _StateCircle extends StatelessWidget {
  const _StateCircle({required this.state});

  final DoseState state;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final (
      Color fill,
      Color border,
      IconData? icon,
      Color iconColor,
    ) = switch (state) {
      DoseState.taken => (
        colors.success,
        colors.success,
        Icons.check_rounded,
        colors.onActive,
      ),
      DoseState.takenLate => (
        colors.warning,
        colors.warning,
        Icons.check_rounded,
        colors.textPrimary,
      ),
      DoseState.skipped => (
        colors.surface,
        colors.textSecondary,
        Icons.remove_rounded,
        colors.textSecondary,
      ),
      DoseState.missed => (
        colors.surface,
        colors.danger,
        Icons.close_rounded,
        colors.danger,
      ),
      DoseState.pending => (
        colors.surface,
        colors.borderHairline,
        null,
        colors.textSecondary,
      ),
    };

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppDurations.standardCurve,
      width: AppSizes.iconXl,
      height: AppSizes.iconXl,
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(color: border, width: AppSizes.borderHairline),
      ),
      child: icon == null
          ? null
          : Icon(icon, size: AppSizes.iconMd, color: iconColor),
    );
  }
}
