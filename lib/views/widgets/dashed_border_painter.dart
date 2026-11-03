import 'dart:ui' show PathMetric;

import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:flutter/rendering.dart';

/// Paints a dashed rounded outline around its widget.
class DashedBorderPainter extends CustomPainter {
  const DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppSizes.borderField;
    final Path outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    for (final PathMetric metric in outline.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + AppSizes.dashLength),
          paint,
        );
        distance += AppSizes.dashLength + AppSizes.dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
