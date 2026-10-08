import 'package:flutter/painting.dart';

/// Raw color values only. This file is the single place hex values live.
///
/// Widgets must NOT read this class directly: they read the `AppColorTokens`
/// ThemeExtension (added in the theme step), which maps these values to
/// semantic roles. That mapping is what lets a dark theme be added later
/// without touching any widget.
abstract final class AppColors {
  // ---- Brand: logo gradient (single source: logo.svg) ----
  static const Color logoPink = Color(0xFFF98CA0);
  static const Color logoViolet = Color(0xFF9B7FE0);
  static const Color logoBlue = Color(0xFF5FA8E8);

  /// 135-degree diagonal, pink -> violet -> blue. Used for every filled
  /// action: primary buttons, FAB, active tab indicator, progress accents.
  static const LinearGradient actionGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[logoPink, logoViolet, logoBlue],
  );

  // ---- Solid active shade (middle gradient stop, used everywhere a
  // gradient cannot be: links, focus ring, cursor, selected icons) ----
  static const Color active = logoViolet;
  static const Color activeTint = Color(0xFFECE7FA);
  static const Color onActive = Color(0xFFFFFFFF);

  // ---- Neutrals ----
  static const Color appBackground = Color(0xFFF7F3EF);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color borderHairline = Color(0xFFECE7E2);
  static const Color progressTrack = Color(0xFFECE9E6);

  // ---- Text ----
  static const Color textPrimary = Color(0xFF23324A);

  /// Darkened from the design's #8B93A0 (about 2.8:1) to reach about 4.5:1
  /// on the cream background, per the approved contrast decision.
  static const Color textSecondary = Color(0xFF667085);

  // ---- Persona / identity colors (never used for actions) ----
  static const Color personaTeal = Color(0xFF3FA79E);
  static const Color personaTealTint = Color(0xFFDFF1EF);
  static const Color personaRose = Color(0xFFE2617A);
  static const Color personaRoseTint = Color(0xFFFBD9DE);
  static const Color personaOrange = Color(0xFFF5A94E);
  static const Color personaOrangeTint = Color(0xFFFCE7CE);
  static const Color personaPurple = Color(0xFF7C63D5);
  static const Color personaPurpleTint = Color(0xFFECE7FA);
  static const Color personaBlue = Color(0xFF4F8FE0);
  static const Color personaBlueTint = Color(0xFFDFEAFB);

  // ---- Semantic status colors (status only, never decoration) ----
  static const Color success = Color(0xFF3FB36F);
  static const Color successTint = Color(0xFFDDF3E6);
  static const Color warning = Color(0xFFF5A94E);
  static const Color warningTint = Color(0xFFFCE7CE);
  static const Color danger = Color(0xFFD6524A);
  static const Color dangerTint = Color(0xFFFBE1DF);

  // ---- Translucent colors (const ARGB, no runtime alpha math) ----
  static const Color shadowSoft = Color(0x1423324A);
  static const Color shadowActive = Color(0x409B7FE0);
  static const Color scrim = Color(0x6623324A);
}
