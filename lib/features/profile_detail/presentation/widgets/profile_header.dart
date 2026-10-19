import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:dose_tracker/views/widgets/persona_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.summary,
    required this.onEdit,
    super.key,
  });

  final ProfileSummary summary;
  final VoidCallback onEdit;

  String get _medicationsText {
    return AppStrings.homeMedicationCount.trParams(<String, String>{
      'count': '${summary.medicationCount}',
    });
  }

  String get _progressText {
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
    final profile = summary.profile;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppColorTokens colors = context.appColors;
    return Semantics(
      label: profile.name,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            PersonaAvatar(
              persona: profile.personaColor,
              avatar: profile.avatar,
              name: profile.name,
              size: PersonaAvatarSize.extraLarge,
            ),
            const SizedBox(height: AppSizes.spaceMd),
            Text(
              profile.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall,
            ),
            Text(
              _medicationsText,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_rounded),
              label: Text(AppStrings.profileEditAction.tr),
              style: TextButton.styleFrom(foregroundColor: colors.active),
            ),
            PersonaProgressBar(
              value: summary.progress,
              persona: profile.personaColor,
            ),
            const SizedBox(height: AppSizes.spaceSm),
            Text(_progressText, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
