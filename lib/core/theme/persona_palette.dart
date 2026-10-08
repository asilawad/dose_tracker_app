import 'dart:ui';

import 'package:dose_tracker/core/theme/app_color_tokens.dart';

/// The identity colors a family profile can use (teal, rose, orange, purple
/// blue). The enum is what gets stored with a profile, so colors can change
/// in the theme without touching saved data. Never used for actions.
enum PersonaColor { teal, rose, orange, purple, blue }

/// A persona's solid color and its soft background tint.
class PersonaShade {
  const PersonaShade({required this.main, required this.tint});

  final Color main;
  final Color tint;
}

extension PersonaColorResolver on PersonaColor {
  /// Resolves this persona to concrete colors from the active theme tokens.
  PersonaShade resolve(AppColorTokens colors) {
    return switch (this) {
      PersonaColor.teal => PersonaShade(
        main: colors.personaTeal,
        tint: colors.personaTealTint,
      ),
      PersonaColor.rose => PersonaShade(
        main: colors.personaRose,
        tint: colors.personaRoseTint,
      ),
      PersonaColor.orange => PersonaShade(
        main: colors.personaOrange,
        tint: colors.personaOrangeTint,
      ),
      PersonaColor.purple => PersonaShade(
        main: colors.personaPurple,
        tint: colors.personaPurpleTint,
      ),
      PersonaColor.blue => PersonaShade(
        main: colors.personaBlue,
        tint: colors.personaBlueTint,
      ),
    };
  }
}
