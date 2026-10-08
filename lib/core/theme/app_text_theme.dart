import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Builds the app [TextTheme] from the design's typography tokens.
///
/// Latin text uses Space Grotesk (display) and Plus Jakarta Sans (body).
/// Both lack Arabic glyphs, so Cairo is the font fallback: Arabic text
/// switches to Cairo automatically and no per-language theme is needed.
/// The family names below must match the `family:` entries in pubspec.yaml.
abstract final class AppTextTheme {
  static const String _displayFamily = 'SpaceGrotesk';
  static const String _bodyFamily = 'PlusJakartaSans';
  static const List<String> _arabicFallback = <String>['Cairo'];

  static TextTheme build(AppColorTokens colors) {
    return TextTheme(
      displayLarge: _style(
        family: _displayFamily,
        size: AppSizes.fontHero,
        line: AppSizes.lineHero,
        weight: FontWeight.w700,
        color: colors.textPrimary,
      ),
      displayMedium: _style(
        family: _displayFamily,
        size: AppSizes.fontHeroMobile,
        line: AppSizes.lineHeroMobile,
        weight: FontWeight.w700,
        color: colors.textPrimary,
      ),
      headlineMedium: _style(
        family: _displayFamily,
        size: AppSizes.fontTitle,
        line: AppSizes.lineTitle,
        weight: FontWeight.w700,
        color: colors.textPrimary,
      ),
      headlineSmall: _style(
        family: _displayFamily,
        size: AppSizes.fontSection,
        line: AppSizes.lineSection,
        weight: FontWeight.w700,
        color: colors.textPrimary,
      ),
      titleLarge: _style(
        family: _displayFamily,
        size: AppSizes.fontStat,
        line: AppSizes.lineStat,
        weight: FontWeight.w700,
        color: colors.textPrimary,
      ),
      titleMedium: _style(
        family: _bodyFamily,
        size: AppSizes.fontBodyBold,
        line: AppSizes.lineBodyBold,
        weight: FontWeight.w700,
        color: colors.textPrimary,
      ),
      bodyLarge: _style(
        family: _bodyFamily,
        size: AppSizes.fontBody,
        line: AppSizes.lineBody,
        weight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      bodyMedium: _style(
        family: _bodyFamily,
        size: AppSizes.fontBodySecondary,
        line: AppSizes.lineBodySecondary,
        weight: FontWeight.w400,
        color: colors.textSecondary,
      ),
      labelLarge: _style(
        family: _displayFamily,
        size: AppSizes.fontTimeSlot,
        line: AppSizes.lineTimeSlot,
        weight: FontWeight.w700,
        color: colors.textPrimary,
        letterSpacing: AppSizes.letterSpacingTimeSlot,
      ),
      labelMedium: _style(
        family: _bodyFamily,
        size: AppSizes.fontBadge,
        line: AppSizes.lineBadge,
        weight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      labelSmall: _style(
        family: _bodyFamily,
        size: AppSizes.fontNav,
        line: AppSizes.lineNav,
        weight: FontWeight.w600,
        color: colors.textSecondary,
      ),
    );
  }

  static TextStyle _style({
    required String family,
    required double size,
    required double line,
    required FontWeight weight,
    required Color color,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: family,
      fontFamilyFallback: _arabicFallback,
      fontSize: size,
      height: line / size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
