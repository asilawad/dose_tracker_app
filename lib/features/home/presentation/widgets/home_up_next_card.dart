import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:dose_tracker/views/widgets/pill_tile.dart';
import 'package:dose_tracker/views/widgets/time_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Home card listing today's next [doses] (design "Up next"): medication
/// icon with the profile badge, name, who it is for and the amount, and the
/// time. Tapping a row calls [onTap], which opens the schedule.
class HomeUpNextCard extends StatelessWidget {
  const HomeUpNextCard({required this.doses, required this.onTap, super.key});

  final List<ScheduledDose> doses;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spaceMd),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < doses.length; i++)
            DecoratedBox(
              decoration: BoxDecoration(
                border: i == 0
                    ? null
                    : Border(
                        top: BorderSide(
                          color: colors.borderHairline,
                          width: AppSizes.borderHairline,
                        ),
                      ),
              ),
              child: _UpNextRow(dose: doses[i], onTap: onTap),
            ),
        ],
      ),
    );
  }
}

class _UpNextRow extends StatelessWidget {
  const _UpNextRow({required this.dose, required this.onTap});

  final ScheduledDose dose;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final String amount =
        '${DoseFormatter.quantity(dose.doseAmount)} ${dose.doseUnit.labelKey.tr}';
    final String subtitle = '${dose.profileName} · $amount';
    final String time = DoseFormatter.minuteOfDay(dose.minuteOfDay);

    return Semantics(
      button: true,
      label: '${dose.medicationName}, $subtitle, $time',
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                PillTile(
                  persona: dose.personaColor,
                  badge: PersonaAvatar(
                    persona: dose.personaColor,
                    size: PersonaAvatarSize.badge,
                    avatar: dose.profileAvatar,
                    name: dose.profileName,
                  ),
                ),
                const SizedBox(width: AppSizes.gutter),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        dose.medicationName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleMedium?.copyWith(fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.spaceSm),
                TimeChip(label: time),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
