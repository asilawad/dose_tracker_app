import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Small pill with the profile name, tinted with the profile's persona color.
class DoseProfileChip extends StatelessWidget {
  const DoseProfileChip({
    required this.name,
    required this.persona,
    super.key,
  });

  final String name;
  final PersonaColor persona;

  @override
  Widget build(BuildContext context) {
    final PersonaShade shade = persona.resolve(context.appColors);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.avatarXl),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: shade.tint,
          borderRadius: BorderRadius.circular(AppSizes.radiusChip),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spaceSm,
            vertical: AppSizes.spaceXs,
          ),
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: shade.main),
          ),
        ),
      ),
    );
  }
}

/// Round check button: outlined when pending, green with a check when taken.
class DoseCheck extends StatelessWidget {
  const DoseCheck({required this.isTaken, this.onTap, super.key});

  final bool isTaken;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens c = context.appColors;

    return IconButton(
      onPressed: onTap,
      tooltip:
          (isTaken ? AppStrings.a11yUndoTaken : AppStrings.a11yMarkTaken).tr,
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
            ? Icon(Icons.check_rounded, size: AppSizes.iconMd, color: c.onActive)
            : null,
      ),
    );
  }
}
