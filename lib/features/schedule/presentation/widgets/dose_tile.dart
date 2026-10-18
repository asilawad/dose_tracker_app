import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/dose_tile_parts.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One medication row inside a time-group card.
/// Title: medication name.
/// Subtitle: "amount unit • meal instruction". Long-press opens skip.
class DoseTile extends StatelessWidget {
  const DoseTile({
    required this.dose,
    this.isTaken,
    this.onToggle,
    this.onSkip,
    super.key,
  });

  final ScheduledDose dose;
  final bool? isTaken;
  final VoidCallback? onToggle;
  final VoidCallback? onSkip;

  String get _subtitle {
    final String amount =
        '${DoseFormatter.quantity(dose.doseAmount)} ${dose.doseUnit.labelKey.tr}';
    final String? meal = dose.mealInstruction?.labelKey.tr;
    return meal == null ? amount : '$amount • $meal';
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final PersonaShade persona = dose.personaColor.resolve(context.appColors);

    final bool checked = isTaken ??
        (dose.state == DoseState.taken || dose.state == DoseState.takenLate);

    return InkWell(
      onLongPress: onSkip,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceSm),
        child: Row(
          children: <Widget>[
            Container(
              width: AppSizes.avatarSm,
              height: AppSizes.avatarSm,
              decoration: BoxDecoration(
                color: persona.tint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medication_rounded,
                size: AppSizes.iconMd,
                color: persona.main,
              ),
            ),
            const SizedBox(width: AppSizes.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          dose.medicationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  Text(_subtitle, style: text.bodyMedium),
                  if (dose.state == DoseState.missed) ...<Widget>[
                    const SizedBox(height: AppSizes.spaceXs),
                    StatusBadge(
                      label: AppStrings.scheduleStateMissed.tr,
                      tone: BadgeTone.danger,
                      icon: Icons.close_rounded,
                    ),
                  ],
                ],
              ),
            ),
            DoseCheck(
              isTaken: checked,
              onTap: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}
