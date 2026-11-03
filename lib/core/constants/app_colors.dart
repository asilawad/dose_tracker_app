import 'package:flutter/painting.dart';

/// Raw color values only. This file is the single place hex values live.
///
/// Values mirror the `:root` tokens of `design/dose_tracker_redesign.html`.
/// Widgets must NOT read this class directly: they read the `AppColorTokens`
/// ThemeExtension, which maps these values to semantic roles. That mapping
/// is what lets a dark theme be added later without touching any widget.
abstract final class AppColors {
  // ---- Brand: logo gradient (single source: logo.svg) ----
  static const Color logoPink = Color(0xFFF98CA0);
  static const Color logoViolet = Color(0xFF9B7FE0);
  static const Color logoBlue = Color(0xFF5FA8E8);

  /// The design's 115-degree sweep, pink -> violet -> blue, used for primary
  /// actions, the hero card and the active tab indicator.
  static const LinearGradient actionGradient = LinearGradient(
    begin: Alignment(-1, -0.47),
    end: Alignment(1, 0.47),
    colors: <Color>[logoPink, logoViolet, logoBlue],
    stops: <double>[0, 0.52, 1],
  );

  // ---- Solid active shades (used wherever a gradient cannot be) ----
  static const Color active = logoViolet;
  static const Color activeDeep = Color(0xFF7A5BD5);
  static const Color activeTint = Color(0xFFEFE9FC);
  static const Color onActive = Color(0xFFFFFFFF);

  // ---- Neutrals ----
  static const Color appBackground = Color(0xFFF5F2EC);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color fieldFill = Color(0xFFF1EDE6);
  static const Color borderHairline = Color(0xFFECE6DC);
  static const Color borderDashed = Color(0xFFCFC4EE);
  static const Color progressTrack = Color(0xFFECE6DC);
  static const Color switchTrackOff = Color(0xFFDCD6CC);
  static const Color sheetHandle = Color(0xFFE0DBD2);
  static const Color radioIdle = Color(0xFFD3CDE0);

  // ---- Text ----
  static const Color textPrimary = Color(0xFF2B2742);
  static const Color textSecondary = Color(0xFF6B6780);
  static const Color textTertiary = Color(0xFFA6A2B4);

  // ---- Persona / identity colors (never used for actions) ----
  static const Color personaTeal = Color(0xFF2F9C8A);
  static const Color personaTealTint = Color(0xFFDCF1EC);
  static const Color personaRose = Color(0xFFE5607A);
  static const Color personaRoseTint = Color(0xFFFCE3E8);
  static const Color personaOrange = Color(0xFFE08A26);
  static const Color personaOrangeTint = Color(0xFFFDEBD5);
  static const Color personaPurple = Color(0xFF8E6BD8);
  static const Color personaPurpleTint = Color(0xFFECE5FA);
  static const Color personaBlue = Color(0xFF3F86D6);
  static const Color personaBlueTint = Color(0xFFE0EDFB);

  // ---- Semantic status colors (status only, never decoration) ----
  static const Color success = Color(0xFF2E9E64);
  static const Color successTint = Color(0xFFDDF3E6);
  static const Color warning = Color(0xFFE08A26);
  static const Color warningTint = Color(0xFFFDEBD5);
  static const Color danger = Color(0xFFDC4F4F);
  static const Color dangerTint = Color(0xFFFBE4E2);

  // ---- Translucent colors (const ARGB, no runtime alpha math) ----
  static const Color shadowHairline = Color(0x0A2B2742);
  static const Color shadowSoft = Color(0x0F2B2742);
  static const Color shadowNav = Color(0x242B2742);
  static const Color shadowActive = Color(0x599B7FE0);
  static const Color shadowIndicator = Color(0x739B7FE0);
  static const Color scrim = Color(0x612B2742);
  static const Color headerGlass = Color(0xDBF5F2EC);
  static const Color appBackgroundClear = Color(0x00F5F2EC);
}
