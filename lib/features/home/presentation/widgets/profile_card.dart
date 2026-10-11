import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';

/// One family member on Home: the avatar in the profile's identity color
/// and the name.
///
/// Tapping the card calls [onTap], which opens the profile for editing.
class ProfileCard extends StatelessWidget {
  const ProfileCard({required this.profile, required this.onTap, super.key});

  final Profile profile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: profile.name,
      child: ExcludeSemantics(
        child: AppCard(
          onTap: onTap,
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
