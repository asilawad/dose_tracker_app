import 'package:dose_tracker/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Semantic color roles that widgets read via `context.appColors`.
///
/// Widgets never touch [AppColors] directly. A future dark theme only adds a
/// second const instance built from other raw values and registers it in
/// the theme layer, so no widget file changes.
@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.appBackground,
    required this.surface,
    required this.borderHairline,
    required this.progressTrack,
    required this.textPrimary,
    required this.textSecondary,
    required this.active,
    required this.activeTint,
    required this.onActive,
    required this.actionGradient,
    required this.personaTeal,
    required this.personaTealTint,
    required this.personaRose,
    required this.personaRoseTint,
    required this.personaOrange,
    required this.personaOrangeTint,
    required this.personaPurple,
    required this.personaPurpleTint,
    required this.personaBlue,
    required this.personaBlueTint,
    required this.success,
    required this.successTint,
    required this.warning,
    required this.warningTint,
    required this.danger,
    required this.dangerTint,
    required this.shadowSoft,
    required this.shadowActive,
    required this.scrim,
  });

  /// Light-mode values. Dark mode will add `AppColorTokens.dark` here.
  static const AppColorTokens light = AppColorTokens(
    appBackground: AppColors.appBackground,
    surface: AppColors.surfaceCard,
    borderHairline: AppColors.borderHairline,
    progressTrack: AppColors.progressTrack,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    active: AppColors.active,
    activeTint: AppColors.activeTint,
    onActive: AppColors.onActive,
    actionGradient: AppColors.actionGradient,
    personaTeal: AppColors.personaTeal,
    personaTealTint: AppColors.personaTealTint,
    personaRose: AppColors.personaRose,
    personaRoseTint: AppColors.personaRoseTint,
    personaOrange: AppColors.personaOrange,
    personaOrangeTint: AppColors.personaOrangeTint,
    personaPurple: AppColors.personaPurple,
    personaPurpleTint: AppColors.personaPurpleTint,
    personaBlue: AppColors.personaBlue,
    personaBlueTint: AppColors.personaBlueTint,
    success: AppColors.success,
    successTint: AppColors.successTint,
    warning: AppColors.warning,
    warningTint: AppColors.warningTint,
    danger: AppColors.danger,
    dangerTint: AppColors.dangerTint,
    shadowSoft: AppColors.shadowSoft,
    shadowActive: AppColors.shadowActive,
    scrim: AppColors.scrim,
  );

  final Color appBackground;
  final Color surface;
  final Color borderHairline;
  final Color progressTrack;
  final Color textPrimary;
  final Color textSecondary;
  final Color active;
  final Color activeTint;
  final Color onActive;
  final LinearGradient actionGradient;
  final Color personaTeal;
  final Color personaTealTint;
  final Color personaRose;
  final Color personaRoseTint;
  final Color personaOrange;
  final Color personaOrangeTint;
  final Color personaPurple;
  final Color personaPurpleTint;
  final Color personaBlue;
  final Color personaBlueTint;
  final Color success;
  final Color successTint;
  final Color warning;
  final Color warningTint;
  final Color danger;
  final Color dangerTint;
  final Color shadowSoft;
  final Color shadowActive;
  final Color scrim;

  @override
  AppColorTokens copyWith({
    Color? appBackground,
    Color? surface,
    Color? borderHairline,
    Color? progressTrack,
    Color? textPrimary,
    Color? textSecondary,
    Color? active,
    Color? activeTint,
    Color? onActive,
    LinearGradient? actionGradient,
    Color? personaTeal,
    Color? personaTealTint,
    Color? personaRose,
    Color? personaRoseTint,
    Color? personaOrange,
    Color? personaOrangeTint,
    Color? personaPurple,
    Color? personaPurpleTint,
    Color? personaBlue,
    Color? personaBlueTint,
    Color? success,
    Color? successTint,
    Color? warning,
    Color? warningTint,
    Color? danger,
    Color? dangerTint,
    Color? shadowSoft,
    Color? shadowActive,
    Color? scrim,
  }) {
    return AppColorTokens(
      appBackground: appBackground ?? this.appBackground,
      surface: surface ?? this.surface,
      borderHairline: borderHairline ?? this.borderHairline,
      progressTrack: progressTrack ?? this.progressTrack,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      active: active ?? this.active,
      activeTint: activeTint ?? this.activeTint,
      onActive: onActive ?? this.onActive,
      actionGradient: actionGradient ?? this.actionGradient,
      personaTeal: personaTeal ?? this.personaTeal,
      personaTealTint: personaTealTint ?? this.personaTealTint,
      personaRose: personaRose ?? this.personaRose,
      personaRoseTint: personaRoseTint ?? this.personaRoseTint,
      personaOrange: personaOrange ?? this.personaOrange,
      personaOrangeTint: personaOrangeTint ?? this.personaOrangeTint,
      personaPurple: personaPurple ?? this.personaPurple,
      personaPurpleTint: personaPurpleTint ?? this.personaPurpleTint,
      personaBlue: personaBlue ?? this.personaBlue,
      personaBlueTint: personaBlueTint ?? this.personaBlueTint,
      success: success ?? this.success,
      successTint: successTint ?? this.successTint,
      warning: warning ?? this.warning,
      warningTint: warningTint ?? this.warningTint,
      danger: danger ?? this.danger,
      dangerTint: dangerTint ?? this.dangerTint,
      shadowSoft: shadowSoft ?? this.shadowSoft,
      shadowActive: shadowActive ?? this.shadowActive,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) {
      return this;
    }
    return AppColorTokens(
      appBackground: _mix(appBackground, other.appBackground, t),
      surface: _mix(surface, other.surface, t),
      borderHairline: _mix(borderHairline, other.borderHairline, t),
      progressTrack: _mix(progressTrack, other.progressTrack, t),
      textPrimary: _mix(textPrimary, other.textPrimary, t),
      textSecondary: _mix(textSecondary, other.textSecondary, t),
      active: _mix(active, other.active, t),
      activeTint: _mix(activeTint, other.activeTint, t),
      onActive: _mix(onActive, other.onActive, t),
      actionGradient: LinearGradient.lerp(
        actionGradient,
        other.actionGradient,
        t,
      )!,
      personaTeal: _mix(personaTeal, other.personaTeal, t),
      personaTealTint: _mix(personaTealTint, other.personaTealTint, t),
      personaRose: _mix(personaRose, other.personaRose, t),
      personaRoseTint: _mix(personaRoseTint, other.personaRoseTint, t),
      personaOrange: _mix(personaOrange, other.personaOrange, t),
      personaOrangeTint: _mix(personaOrangeTint, other.personaOrangeTint, t),
      personaPurple: _mix(personaPurple, other.personaPurple, t),
      personaPurpleTint: _mix(personaPurpleTint, other.personaPurpleTint, t),
      personaBlue: _mix(personaBlue, other.personaBlue, t),
      personaBlueTint: _mix(personaBlueTint, other.personaBlueTint, t),
      success: _mix(success, other.success, t),
      successTint: _mix(successTint, other.successTint, t),
      warning: _mix(warning, other.warning, t),
      warningTint: _mix(warningTint, other.warningTint, t),
      danger: _mix(danger, other.danger, t),
      dangerTint: _mix(dangerTint, other.dangerTint, t),
      shadowSoft: _mix(shadowSoft, other.shadowSoft, t),
      shadowActive: _mix(shadowActive, other.shadowActive, t),
      scrim: _mix(scrim, other.scrim, t),
    );
  }

  static Color _mix(Color a, Color b, double t) => Color.lerp(a, b, t)!;
}

/// Shortcut so widgets write `context.appColors.textPrimary`.
extension AppColorTokensContext on BuildContext {
  AppColorTokens get appColors => Theme.of(this).extension<AppColorTokens>()!;
}
