import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Pill-shaped option for single-choice groups, for example the dose unit or
/// the meal instruction.
///
/// The chosen chip is filled with the active color; the others are plain.
/// Set [showCheck] to add a check mark on the chosen chip. [label] must
/// already be translated. The tap target is at least 48 px high and the
/// chip announces itself as a selectable button.
class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.showCheck = false,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusChip);
    final Color foreground = selected ? colors.onActive : colors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppDurations.standardCurve,
          decoration: BoxDecoration(
            color: selected ? colors.active : colors.appBackground,
            borderRadius: radius,
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: onTap,
              child: SizedBox(
                height: AppSizes.minTapTarget,
                child: Center(
                  widthFactor: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spaceLg,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (selected && showCheck) ...<Widget>[
                          Icon(
                            Icons.check_rounded,
                            size: AppSizes.iconSm,
                            color: foreground,
                          ),
                          const SizedBox(width: AppSizes.spaceXs),
                        ],
                        Text(
                          label,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(color: foreground),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
