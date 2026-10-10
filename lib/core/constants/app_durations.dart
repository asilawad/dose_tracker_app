import 'package:flutter/animation.dart';

/// Every animation duration and curve in the app.
///
/// Splash timings follow the navigation map: the logo scales and fades in
/// (about 600 ms), then the name and tagline fade in, then the app moves on
/// after roughly two seconds in total.
abstract final class AppDurations {
  // ---- Generic UI motion ----
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  // ---- Component motion ----
  static const Duration buttonPress = Duration(milliseconds: 120);
  static const Duration progressFill = Duration(milliseconds: 400);
  static const Duration bottomSheet = Duration(milliseconds: 250);
  static const Duration pageTransition = Duration(milliseconds: 300);
  static const Duration onboardingPage = Duration(milliseconds: 350);
  static const Duration tabSwitch = Duration(milliseconds: 200);

  // ---- Splash sequence ----
  static const Duration splashLogoEntrance = Duration(milliseconds: 600);
  static const Duration splashTextEntrance = Duration(milliseconds: 400);
  static const Duration splashTextDelay = Duration(milliseconds: 500);
  static const Duration splashTotal = Duration(milliseconds: 2000);

  // ---- Feedback and timing ----
  static const Duration snackbarVisible = Duration(seconds: 3);
  static const Duration inputDebounce = Duration(milliseconds: 300);

  /// How often the schedule re-checks which pending doses became missed.
  static const Duration scheduleRefresh = Duration(minutes: 1);
  // ---- Curves ----
  static const Curve standardCurve = Curves.easeOutCubic;
  static const Curve emphasizedCurve = Curves.easeInOutCubic;
  static const Curve entranceCurve = Curves.easeOutBack;
}
