import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Rounded progress bar filled with a profile's persona color.
///
/// [value] is a fraction from 0 to 1 (values outside are clamped) and the
/// fill animates when it changes. The fill starts from the leading edge, so
/// it mirrors automatically in RTL.
class PersonaProgressBar extends StatelessWidget {
  const PersonaProgressBar({
    required this.value,
    required this.persona,
    super.key,
  });

  final double value;
  final PersonaColor persona;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final double fraction = value.clamp(0.0, 1.0);
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusFull);

    return Semantics(
      value: NumberFormat.percentPattern().format(fraction),
      child: ExcludeSemantics(
        child: SizedBox(
          height: AppSizes.progressBarHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.progressTrack,
              borderRadius: radius,
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: fraction),
              duration: AppDurations.progressFill,
              curve: AppDurations.standardCurve,
              builder: (BuildContext context, double animated, Widget? _) {
                return FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: animated,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: persona.resolve(colors).main,
                      borderRadius: radius,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
