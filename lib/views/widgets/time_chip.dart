import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Small violet pill for a time such as "8:00 AM" (design `.time-chip`).
/// [label] must already be formatted for the current locale.
class TimeChip extends StatelessWidget {
  const TimeChip({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.activeTint,
        borderRadius: BorderRadius.circular(AppSizes.radiusChip),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.activeDeep,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
