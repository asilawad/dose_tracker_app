import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
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

    return Opacity(
      opacity: isEnabled ? 1 : 0.5,
      child: IconButton(
        onPressed: isEnabled ? onTap : null,
        tooltip:
            (isNotYetDue
                    ? AppStrings.scheduleNotYetDue
                    : isTaken
                    ? AppStrings.a11yUndoTaken
                    : AppStrings.a11yMarkTaken)
                .tr,
        icon: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppDurations.standardCurve,
          width: AppSizes.iconXl,
          height: AppSizes.iconXl,
          decoration: BoxDecoration(
            color: isTaken ? c.success : c.surface,
            shape: BoxShape.circle,
            border: Border.all(color: isTaken ? c.success : c.borderHairline),
          ),
          child: isTaken
              ? Icon(
                  Icons.check_rounded,
                  size: AppSizes.iconMd,
                  color: c.onActive,
                )
              : null,
        ),
      ),
    );
  }
}
