import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/app_segment_button.dart';
import 'package:dose_tracker/views/widgets/app_segment_option.dart';
import 'package:flutter/material.dart';

/// Equal-width single-choice control, for example All / Low stock.
///
/// [selected] may be null when no option is chosen, as with an optional
/// meal instruction; the parent decides what a repeat tap means.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<AppSegmentOption<T>> options;
  final T? selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.fieldFill,
        borderRadius: BorderRadius.circular(AppSizes.radiusSegmentTrack),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceXs),
        child: Row(
          spacing: AppSizes.spaceXs,
          children: <Widget>[
            for (final AppSegmentOption<T> option in options)
              Expanded(
                child: AppSegmentButton(
                  label: option.label,
                  selected: option.value == selected,
                  onTap: () => onChanged(option.value),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
