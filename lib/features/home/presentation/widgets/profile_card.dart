import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:dose_tracker/views/widgets/persona_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One family member on Home: avatar in the identity color, name, number of
/// medications, a chevron, and today's progress bar with "taken of total".
///
/// Tapping the card calls [onTap].
class ProfileCard extends StatelessWidget {
  const ProfileCard({required this.summary, required this.onTap, super.key});

  final ProfileSummary summary;
  final VoidCallback onTap;

  String get _medicationsText {
    if (summary.medicationCount == 0) {
      return AppStrings.homeNoMedications.tr;
    }
    return AppStrings.homeMedicationCount.trParams(<String, String>{
      'count': '${summary.medicationCount}',
    });
  }

  String get _dosesText {
    if (summary.totalToday == 0) {
      return AppStrings.homeNoDosesToday.tr;
    }
    return AppStrings.homeDosesProgress.trParams(<String, String>{
      'taken': '${summary.takenToday}',
      'total': '${summary.totalToday}',
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return Semantics(
      button: true,
      label: summary.profile.name,
      child: ExcludeSemantics(
        child: AppCard(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  PersonaAvatar(persona: summary.profile.personaColor),
                  const SizedBox(width: AppSizes.spaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          summary.profile.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          _medicationsText,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isRtl
                        ? Icons.chevron_left_rounded
                        : Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spaceMd),
              PersonaProgressBar(
                value: summary.progress,
                persona: summary.profile.personaColor,
              ),
              const SizedBox(height: AppSizes.spaceSm),
              Text(_dosesText, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
