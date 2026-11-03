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
  static const Duration navHop = Duration(milliseconds: 560);
  static const Duration navIconRise = Duration(milliseconds: 600);
  static const Duration navIconDrop = Duration(milliseconds: 380);
  static const Duration switchToggle = Duration(milliseconds: 250);

  // ---- Splash sequence ----
  static const Duration splashLogoEntrance = Duration(milliseconds: 600);
  static const Duration splashTextEntrance = Duration(milliseconds: 400);
  static const Duration splashTextDelay = Duration(milliseconds: 500);
  static const Duration splashTotal = Duration(milliseconds: 2000);

  // ---- Feedback and timing ----
  static const Duration snackbarVisible = Duration(seconds: 3);
  /// How long the "Undo" snackbar stays, long enough to react to a mistaken tap.
  static const Duration undoSnackbarVisible = Duration(seconds: 8);
  static const Duration inputDebounce = Duration(milliseconds: 300);

  /// How often the schedule re-checks which pending doses became missed.
  static const Duration scheduleRefresh = Duration(minutes: 1);
  // ---- Curves ----
  static const Curve standardCurve = Curves.easeOutCubic;
  static const Curve emphasizedCurve = Curves.easeInOutCubic;
  static const Curve entranceCurve = Curves.easeOutBack;

  /// Overshoot of the switch thumb, from the design's cubic-bezier.
  static const Curve switchCurve = Cubic(0.3, 1.4, 0.6, 1);

  /// The active tab icon waits 220 ms for the circle to arrive, then pops up
  /// with a light elastic settle.
  static const Curve navIconRiseCurve = Interval(
    0.367,
    1,
    curve: ElasticOutCurve(0.8),
  );
}
