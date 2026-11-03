import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// The design's on/off switch. The thumb follows the reading direction.
///
/// Disabled when [onChanged] is null. [semanticLabel] must already be
/// translated. The visible track is shorter than the 40 px tap area.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final bool enabled = onChanged != null;
    final Duration duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : AppDurations.switchToggle;

    return Semantics(
      toggled: value,
      enabled: enabled,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? () => onChanged!(!value) : null,
          child: SizedBox(
            height: AppSizes.switchTapHeight,
            child: Center(
              widthFactor: 1,
              child: Opacity(
                opacity: enabled ? 1 : AppSizes.disabledOpacity,
                child: AnimatedContainer(
                  duration: duration,
                  width: AppSizes.switchWidth,
                  height: AppSizes.switchHeight,
                  padding: const EdgeInsets.all(AppSizes.switchInset),
                  decoration: BoxDecoration(
                    color: value ? colors.active : colors.switchTrackOff,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: AnimatedAlign(
                    duration: duration,
                    curve: AppDurations.switchCurve,
                    alignment: value
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.onActive,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: colors.shadowNav,
                            blurRadius: AppSizes.shadowBlurSwitchThumb,
                            offset: const Offset(
                              0,
                              AppSizes.shadowOffsetYSwitchThumb,
                            ),
                          ),
                        ],
                      ),
                      child: const SizedBox.square(
                        dimension: AppSizes.switchThumbSize,
                      ),
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
