import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/presentation/widgets/dose_tile_parts.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:dose_tracker/views/widgets/pill_tile.dart';
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
    this.isJustChecked = false,
    this.onToggle,
    this.onSkip,
    this.showProfile = false,
    super.key,
  });

  final ScheduledDose dose;
  final bool? isTaken;
  final bool isJustChecked;
  final VoidCallback? onToggle;
  final VoidCallback? onSkip;

  /// Adds the profile badge on the icon and the name to the subtitle.
  final bool showProfile;

  String get _subtitle {
    final String amount =
        '${DoseFormatter.quantity(dose.doseAmount)} ${dose.doseUnit.labelKey.tr}';
    final String? meal = dose.mealInstruction?.labelKey.tr;
    return <String>[
      if (showProfile) dose.profileName,
      amount,
      ?meal,
    ].join(' \u00B7 ');
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final AppColorTokens colors = context.appColors;

    final bool checked =
        isTaken ??
        (dose.state == DoseState.taken || dose.state == DoseState.takenLate);

    return InkWell(
      onLongPress: dose.canRecord ? onSkip : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            PillTile(
              persona: dose.personaColor,
              badge: showProfile
                  ? PersonaAvatar(
                      persona: dose.personaColor,
                      size: PersonaAvatarSize.badge,
                      avatar: dose.profileAvatar,
                      name: dose.profileName,
                    )
                  : null,
            ),
            const SizedBox(width: AppSizes.gutter),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          dose.medicationName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleMedium?.copyWith(
                            fontSize: 15,
                            color: checked ? colors.textSecondary : null,
                          ),
                        ),
                      ),
                      if (dose.state == DoseState.missed) ...<Widget>[
                        const SizedBox(width: 6),
                        StatusBadge(
                          label: AppStrings.scheduleStateMissed.tr,
                          tone: BadgeTone.danger,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodyMedium,
                  ),
                ],
              ),
            ),
            DoseCheck(
              isTaken: checked,
              isEnabled: dose.canRecord || isJustChecked,
              isNotYetDue: dose.state == DoseState.pending && !dose.isDue,
              onTap: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}
