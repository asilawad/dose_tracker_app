import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/dashed_border_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Round check button: outlined when pending, green with a check when taken.
class DoseCheck extends StatelessWidget {
  const DoseCheck({
    required this.isTaken,
    required this.isEnabled,
    required this.isNotYetDue,
    this.onTap,
    super.key,
  });

  final bool isTaken;
  final bool isEnabled;
  final bool isNotYetDue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens c = context.appColors;

    const double size = AppSizes.doseCheckSize;
    final Widget circle;
    if (isNotYetDue && !isTaken) {
      circle = CustomPaint(
        painter: DashedBorderPainter(color: c.borderDashed, radius: size / 2),
        child: SizedBox.square(
          dimension: size,
          child: Icon(
            Icons.schedule_rounded,
            size: AppSizes.iconSm,
            color: c.textTertiary,
          ),
        ),
      );
    } else {
      circle = AnimatedContainer(
        duration: AppDurations.fast,
        curve: AppDurations.standardCurve,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isTaken ? c.success : c.surface,
          shape: BoxShape.circle,
          border: Border.all(
            color: isTaken ? c.success : c.radioIdle,
            width: AppSizes.borderEmphasis,
          ),
        ),
        child: isTaken
            ? Icon(
                Icons.check_rounded,
                size: AppSizes.iconMd,
                color: c.onActive,
              )
            : null,
      );
    }

    return Opacity(
      opacity: isEnabled || isNotYetDue ? 1 : 0.5,
      child: IconButton(
        onPressed: isEnabled ? onTap : null,
        tooltip:
            (isNotYetDue
                    ? AppStrings.scheduleNotYetDue
                    : isTaken
                    ? AppStrings.a11yUndoTaken
                    : AppStrings.a11yMarkTaken)
                .tr,
        icon: circle,
      ),
    );
  }
}
