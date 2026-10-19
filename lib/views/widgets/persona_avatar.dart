import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/core/utils/avatar_initial.dart';
import 'package:dose_tracker/features/profiles/data/models/profile_avatar.dart';
import 'package:flutter/material.dart';

/// Preset avatar sizes. Each maps to an avatar diameter and a matching icon
/// size from [AppSizes], so call sites never pass raw numbers.
enum PersonaAvatarSize {
  small(AppSizes.avatarSm, AppSizes.iconMd),
  medium(AppSizes.avatarMd, AppSizes.iconLg),
  large(AppSizes.avatarLg, AppSizes.iconXl),
  extraLarge(AppSizes.avatarXl, AppSizes.iconXl);

  const PersonaAvatarSize(this.diameter, this.iconSize);

  final double diameter;
  final double iconSize;
}

/// Circular profile avatar: soft persona tint behind a person icon in the
/// persona's main color. Identity only, never an action color.
class PersonaAvatar extends StatelessWidget {
  const PersonaAvatar({
    required this.persona,
    this.size = PersonaAvatarSize.medium,
    this.avatar,
    this.name,
    super.key,
  });

  final PersonaColor persona;
  final PersonaAvatarSize size;
  final ProfileAvatar? avatar;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final PersonaShade shade = persona.resolve(context.appColors);

    return ExcludeSemantics(
      child: Container(
        width: size.diameter,
        height: size.diameter,
        decoration: BoxDecoration(color: shade.tint, shape: BoxShape.circle),
        child: Center(
          child: avatar != null
              ? Text(
                  avatar!.emoji,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(fontSize: size.iconSize),
                )
              : name != null
              ? Text(
                  AvatarInitial.of(name!),
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: shade.main,
                    fontSize: size.iconSize,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Icon(
                  Icons.person_rounded,
                  size: size.iconSize,
                  color: shade.main,
                ),
        ),
      ),
    );
  }
}
