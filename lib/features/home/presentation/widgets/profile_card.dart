import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';

/// One family member on Home: the avatar in the profile's identity color
/// and the name.
///
/// It is not tappable yet. Medication counts, the adherence bar and the
/// tap to open the profile are added with the screens that need them.
class ProfileCard extends StatelessWidget {
  const ProfileCard({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: profile.name,
      child: ExcludeSemantics(
        child: AppCard(
          child: Row(
            children: <Widget>[
              PersonaAvatar(persona: profile.personaColor),
              const SizedBox(width: AppSizes.spaceMd),
              Expanded(
                child: Text(
                  profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
