import 'dart:math' as math;

import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Circular progress ring from the redesign (`.ring`), drawn around a
/// [child] such as an avatar or a "3/12" label.
///
/// [value] is clamped to 0..1 and animates when it changes. The ring starts
/// at the top and fills clockwise in both text directions.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.value,
    required this.color,
    required this.size,
    required this.strokeWidth,
    this.child,
    super.key,
  });

  final double value;
  final Color color;
  final double size;
  final double strokeWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final double fraction = value.clamp(0.0, 1.0);

    return Semantics(
      value: NumberFormat.percentPattern().format(fraction),
      child: SizedBox.square(
        dimension: size,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(end: fraction),
          duration: AppDurations.progressFill,
          curve: AppDurations.standardCurve,
          builder: (BuildContext context, double animated, Widget? inner) {
            return CustomPaint(
              painter: _RingPainter(
                value: animated,
                color: color,
                track: colors.progressTrack,
                strokeWidth: strokeWidth,
              ),
              child: Center(child: inner),
            );
          },
          child: child,
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.color,
    required this.track,
    required this.strokeWidth,
  });

  final double value;
  final Color color;
  final Color track;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Rect arcRect = rect.deflate(strokeWidth / 2);
    final Paint base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, 0, math.pi * 2, false, base..color = track);
    if (value > 0) {
      canvas.drawArc(
        arcRect,
        -math.pi / 2,
        math.pi * 2 * value,
        false,
        base..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value ||
      old.color != color ||
      old.track != track ||
      old.strokeWidth != strokeWidth;
}
