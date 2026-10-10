import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Compact plus/minus control with the current value between the buttons,
/// for example the daily frequency "2 times".
///
/// Leave [onIncrement] or [onDecrement] null to disable that button at the
/// limit. [valueLabel] and both tooltips must already be translated. Each
/// button is a 48 px tap target, and the value is announced when it changes.
class AppStepper extends StatelessWidget {
  const AppStepper({
    required this.valueLabel,
    required this.onIncrement,
    required this.onDecrement,
    required this.incrementTooltip,
    required this.decrementTooltip,
    super.key,
  });

  final String valueLabel;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final String incrementTooltip;
  final String decrementTooltip;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.appBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            tooltip: decrementTooltip,
            onPressed: onDecrement,
            color: colors.active,
            disabledColor: colors.textSecondary,
            icon: const Icon(Icons.remove_rounded),
          ),
          Semantics(
            liveRegion: true,
            label: valueLabel,
            child: ExcludeSemantics(
              child: Text(
                valueLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          IconButton(
            tooltip: incrementTooltip,
            onPressed: onIncrement,
            color: colors.active,
            disabledColor: colors.textSecondary,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
