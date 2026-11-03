import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Builds the app [TextTheme] from the design's type scale.
///
/// Readex Pro covers Latin and Arabic, so one family serves both languages
/// and no per-language theme is needed. [family] must match the `family:`
/// entry in pubspec.yaml.
abstract final class AppTextTheme {
  static const String family = 'ReadexPro';

  static TextTheme build(AppColorTokens colors) {
    return TextTheme(
      displayLarge: _style(
        size: AppSizes.fontHero,
        line: AppSizes.lineHero,
        weight: FontWeight.w600,
        color: colors.textPrimary,
        letterSpacing: AppSizes.letterSpacingHero,
      ),
      displayMedium: _style(
        size: AppSizes.fontHeroMobile,
        line: AppSizes.lineHeroMobile,
        weight: FontWeight.w600,
        color: colors.textPrimary,
        letterSpacing: AppSizes.letterSpacingDisplay,
      ),
      headlineMedium: _style(
        size: AppSizes.fontTitle,
        line: AppSizes.lineTitle,
        weight: FontWeight.w600,
        color: colors.textPrimary,
        letterSpacing: AppSizes.letterSpacingTitle,
      ),
      headlineSmall: _style(
        size: AppSizes.fontSection,
        line: AppSizes.lineSection,
        weight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      titleLarge: _style(
        size: AppSizes.fontStat,
        line: AppSizes.lineStat,
        weight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      titleMedium: _style(
        size: AppSizes.fontBodyBold,
        line: AppSizes.lineBodyBold,
        weight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      titleSmall: _style(
        size: AppSizes.fontBodySecondary,
        line: AppSizes.lineBodySecondary,
        weight: FontWeight.w500,
        color: colors.textSecondary,
      ),
      bodyLarge: _style(
        size: AppSizes.fontBody,
        line: AppSizes.lineBody,
        weight: FontWeight.w400,
        color: colors.textPrimary,
      ),
      bodyMedium: _style(
        size: AppSizes.fontBodySecondary,
        line: AppSizes.lineBodySecondary,
        weight: FontWeight.w400,
        color: colors.textSecondary,
      ),
      bodySmall: _style(
        size: AppSizes.fontCaption,
        line: AppSizes.lineCaption,
        weight: FontWeight.w400,
        color: colors.textTertiary,
      ),
      labelLarge: _style(
        size: AppSizes.fontTimeSlot,
        line: AppSizes.lineTimeSlot,
        weight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      labelMedium: _style(
        size: AppSizes.fontBadge,
        line: AppSizes.lineBadge,
        weight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      labelSmall: _style(
        size: AppSizes.fontNav,
        line: AppSizes.lineNav,
        weight: FontWeight.w500,
        color: colors.textTertiary,
      ),
    );
  }

  static TextStyle _style({
    required double size,
    required double line,
    required FontWeight weight,
    required Color color,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      height: line / size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
