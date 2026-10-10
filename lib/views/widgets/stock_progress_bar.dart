import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Thin rounded bar showing how much stock is left, from empty to full.
///
/// [fraction] is clamped to 0 to 1. The fill uses the active color, or the
/// danger color when [isLow] is true; the fill animates when the value
/// changes and starts from the start edge (right in Arabic). The bar is
/// decoration only: the screen that shows it must also give the numbers as
/// text, so the bar is hidden from screen readers.
class StockProgressBar extends StatelessWidget {
  const StockProgressBar({
    required this.fraction,
    this.isLow = false,
    super.key,
  });

  final double fraction;
  final bool isLow;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusFull);

    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          height: AppSizes.progressBarHeight,
          child: ColoredBox(
            color: colors.appBackground,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: fraction.clamp(0.0, 1.0).toDouble()),
              duration: AppDurations.normal,
              curve: AppDurations.standardCurve,
              builder: (BuildContext context, double value, Widget? child) {
                return Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FractionallySizedBox(
                    widthFactor: value,
                    heightFactor: 1,
                    child: child,
                  ),
                );
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isLow ? colors.danger : colors.active,
                  borderRadius: radius,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
