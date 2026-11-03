import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// One tappable segment inside an `AppSegmentedControl`.
class AppSegmentButton extends StatelessWidget {
  const AppSegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: AnimatedContainer(
            duration: AppDurations.tabSwitch,
            height: AppSizes.segmentHeight,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spaceXs,
            ),
            decoration: BoxDecoration(
              color: selected ? colors.surface : colors.fieldFill,
              borderRadius: BorderRadius.circular(AppSizes.radiusSegment),
              boxShadow: selected
                  ? <BoxShadow>[
                      BoxShadow(
                        color: colors.shadowSoft,
                        blurRadius: AppSizes.shadowBlurSegment,
                        offset: const Offset(
                          0,
                          AppSizes.shadowOffsetYSegment,
                        ),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: AppSizes.fontChip,
                fontWeight: FontWeight.w500,
                color: selected ? colors.textPrimary : colors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
