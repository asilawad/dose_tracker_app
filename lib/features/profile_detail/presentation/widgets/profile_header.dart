import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:dose_tracker/views/widgets/progress_ring.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Centered ring avatar, name and today's progress at the top of a family
/// member's page (design "member" screen).
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.summary, super.key});

  final ProfileSummary summary;

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
    final Profile profile = summary.profile;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppColorTokens colors = context.appColors;

    return Semantics(
      container: true,
      label: profile.name,
      value: _progressText,
      child: ExcludeSemantics(
        child: Column(
          children: <Widget>[
            ProgressRing(
              value: summary.progress,
              color: profile.personaColor.resolve(colors).main,
              size: 116,
              strokeWidth: 6,
              child: PersonaAvatar(
                persona: profile.personaColor,
                avatar: profile.avatar,
                name: profile.name,
                size: PersonaAvatarSize.extraLarge,
              ),
            ),
            const SizedBox(height: AppSizes.gutter),
            Text(
              profile.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 2),
            Text(
              _progressText,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
