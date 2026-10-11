import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:flutter/painting.dart';

/// How good an adherence rate is, in one place so every part of the report
/// screen colors it the same way: 85% or more is good, 60% or more is fair,
/// and anything lower is poor.
abstract final class ReportRate {
  static const double goodThreshold = 0.85;
  static const double fairThreshold = 0.6;

  static BadgeTone toneOf(double rate) {
    if (rate >= goodThreshold) {
      return BadgeTone.success;
    }
    return rate >= fairThreshold ? BadgeTone.warning : BadgeTone.danger;
  }

  /// The color for text and bars showing [rate].
  static Color colorOf(double rate, AppColorTokens colors) {
    return switch (toneOf(rate)) {
      BadgeTone.success => colors.success,
      BadgeTone.warning => colors.warning,
      BadgeTone.danger || BadgeTone.active => colors.danger,
    };
  }

  static bool isPoor(double rate) => toneOf(rate) == BadgeTone.danger;
}
