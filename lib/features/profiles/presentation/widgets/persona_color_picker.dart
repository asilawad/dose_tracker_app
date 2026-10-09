import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Row of identity-color swatches. All five colors are always available.
///
/// The chosen swatch shows a check and a ring in its own color. Each swatch
/// is a 48 px tap target and announces its color name to screen readers.
class PersonaColorPicker extends StatelessWidget {
  const PersonaColorPicker({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final PersonaColor selected;
  final ValueChanged<PersonaColor> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSizes.gutter,
      runSpacing: AppSizes.gutter,
      children: <Widget>[
        for (final PersonaColor color in PersonaColor.values)
          _Swatch(
            color: color,
            selected: color == selected,
            onTap: () => onChanged(color),
          ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final PersonaColor color;
  final bool selected;
  final VoidCallback onTap;

  static String _nameKey(PersonaColor color) {
    return switch (color) {
      PersonaColor.teal => AppStrings.personaColorTeal,
      PersonaColor.rose => AppStrings.personaColorRose,
      PersonaColor.orange => AppStrings.personaColorOrange,
      PersonaColor.purple => AppStrings.personaColorPurple,
      PersonaColor.blue => AppStrings.personaColorBlue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final PersonaShade shade = color.resolve(colors);

    return Semantics(
      button: true,
      selected: selected,
      label: _nameKey(color).tr,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: AppSizes.avatarMd,
            height: AppSizes.avatarMd,
            child: AnimatedContainer(
              duration: AppDurations.fast,
              curve: AppDurations.standardCurve,
              padding: const EdgeInsets.all(AppSizes.spaceXs),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? shade.main : colors.surface,
                  width: AppSizes.borderEmphasis,
                ),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: shade.main,
                  shape: BoxShape.circle,
                ),
                child: selected
                    ? Icon(
                        Icons.check_rounded,
                        size: AppSizes.iconMd,
                        color: colors.onActive,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
