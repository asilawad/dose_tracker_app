import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:flutter/material.dart';

/// The small time pill that starts each group of doses in the schedule, for
/// example 9:00 AM. It sits at the start edge (right in Arabic).
class DoseTimeHeader extends StatelessWidget {
  const DoseTimeHeader({required this.minuteOfDay, super.key});

  final int minuteOfDay;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.activeTint,
          borderRadius: BorderRadius.circular(AppSizes.radiusChip),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceMd,
            vertical: AppSizes.spaceXs,
          ),
          child: Text(
            DoseFormatter.minuteOfDay(minuteOfDay),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: colors.active),
          ),
        ),
      ),
    );
  }
}
