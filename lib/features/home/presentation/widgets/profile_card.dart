import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:dose_tracker/views/widgets/progress_ring.dart';
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
    final AppColorTokens colors = context.appColors;

    return Semantics(
      button: true,
      label: summary.profile.name,
      value: _dosesText,
      child: ExcludeSemantics(
        child: AppCard(
          onTap: onTap,
          child: Row(
            children: <Widget>[
              ProgressRing(
                value: summary.progress,
                color: summary.profile.personaColor.resolve(colors).main,
                size: 60,
                strokeWidth: 4,
                child: PersonaAvatar(
                  persona: summary.profile.personaColor,
                  avatar: summary.profile.avatar,
                  name: summary.profile.name,
                ),
              ),
              const SizedBox(width: AppSizes.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      summary.profile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$_medicationsText · $_dosesText',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
