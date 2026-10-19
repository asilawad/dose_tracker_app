import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/profiles/data/models/profile_avatar.dart';
import 'package:flutter/foundation.dart';

/// The public view of a family profile: only what screens may show.
///
/// Screens never see the database row. The repository builds this from it.
/// Only the [id] travels between routes, never this object.
@immutable
class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.personaColor,
    required this.remindersEnabled,
    this.avatar,
  });

  final int id;
  final String name;
  final PersonaColor personaColor;
  final bool remindersEnabled;
  final ProfileAvatar? avatar;

  @override
  bool operator ==(Object other) {
    return other is Profile &&
        other.id == id &&
        other.name == name &&
        other.personaColor == personaColor &&
        other.remindersEnabled == remindersEnabled &&
        other.avatar == avatar;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    personaColor,
    remindersEnabled,
    avatar,
  );
}
