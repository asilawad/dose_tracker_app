import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';

/// A horizontally scrolling row of family members to choose from: avatar
/// and name in a pill, with the chosen one outlined in the active color.
///
/// [onSelect] gets the id of the tapped profile. Each pill is a button of
/// at least 48 px that announces its name and whether it is selected.
class CalendarProfileChips extends StatelessWidget {
  const CalendarProfileChips({
    required this.profiles,
    required this.selectedId,
    required this.onSelect,
    super.key,
  });

  final List<Profile> profiles;
  final int? selectedId;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (final Profile profile in profiles)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSizes.spaceSm),
              child: _ProfileChip(
                profile: profile,
                selected: profile.id == selectedId,
                onTap: () => onSelect(profile.id),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({
    required this.profile,
    required this.selected,
    required this.onTap,
  });

  final Profile profile;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusFull);

    return Semantics(
      button: true,
      selected: selected,
      label: profile.name,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? colors.activeTint : colors.surface,
            borderRadius: radius,
            border: Border.all(
              color: selected ? colors.active : colors.borderHairline,
              width: selected
                  ? AppSizes.borderEmphasis
                  : AppSizes.borderHairline,
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              borderRadius: radius,
              onTap: onTap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppSizes.minTapTarget,
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSizes.spaceSm,
                    end: AppSizes.spaceLg,
                    top: AppSizes.spaceXs,
                    bottom: AppSizes.spaceXs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      PersonaAvatar(
                        persona: profile.personaColor,
                        size: PersonaAvatarSize.small,
                      ),
                      const SizedBox(width: AppSizes.spaceSm),
                      Text(
                        profile.name,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: selected ? colors.active : null,
                        ),
                      ),
                    ],
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
