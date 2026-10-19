import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/core/utils/avatar_initial.dart';
import 'package:dose_tracker/features/profiles/data/models/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    required this.name,
    required this.persona,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final String name;
  final PersonaColor persona;
  final ProfileAvatar? selected;
  final ValueChanged<ProfileAvatar?> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final PersonaShade shade = persona.resolve(colors);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSizes.spaceSm,
      runSpacing: AppSizes.spaceSm,
      children: <Widget>[
        _AvatarOption(
          label: AppStrings.profileAvatarFirstLetter.tr,
          selected: selected == null,
          onTap: () => onChanged(null),
          content: Text(
            AvatarInitial.of(name),
            textScaler: TextScaler.noScaling,
            style: TextStyle(
              color: shade.main,
              fontSize: AppSizes.iconLg,
              fontWeight: FontWeight.bold,
            ),
          ),
          shade: shade,
        ),
        for (final ProfileAvatar avatar in ProfileAvatar.values)
          _AvatarOption(
            label: _labelFor(avatar).tr,
            selected: selected == avatar,
            onTap: () => onChanged(avatar),
            content: Text(
              avatar.emoji,
              textScaler: TextScaler.noScaling,
              style: const TextStyle(fontSize: AppSizes.iconLg),
            ),
            shade: shade,
          ),
      ],
    );
  }

  static String _labelFor(ProfileAvatar avatar) {
    return switch (avatar) {
      ProfileAvatar.man => AppStrings.profileAvatarMan,
      ProfileAvatar.woman => AppStrings.profileAvatarWoman,
      ProfileAvatar.boy => AppStrings.profileAvatarBoy,
      ProfileAvatar.girl => AppStrings.profileAvatarGirl,
      ProfileAvatar.baby => AppStrings.profileAvatarBaby,
      ProfileAvatar.grandfather => AppStrings.profileAvatarGrandfather,
      ProfileAvatar.grandmother => AppStrings.profileAvatarGrandmother,
      ProfileAvatar.person => AppStrings.profileAvatarPerson,
      ProfileAvatar.beard => AppStrings.profileAvatarBeard,
      ProfileAvatar.blond => AppStrings.profileAvatarBlond,
      ProfileAvatar.cat => AppStrings.profileAvatarCat,
      ProfileAvatar.dog => AppStrings.profileAvatarDog,
    };
  }
}

class _AvatarOption extends StatelessWidget {
  const _AvatarOption({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.content,
    required this.shade,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget content;
  final PersonaShade shade;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: SizedBox(
          width: AppSizes.minTapTarget,
          height: AppSizes.minTapTarget,
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Center(
              child: Container(
                width: AppSizes.avatarSm,
                height: AppSizes.avatarSm,
                decoration: BoxDecoration(
                  color: shade.tint,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? shade.main : colors.borderHairline,
                    width: selected
                        ? AppSizes.borderEmphasis
                        : AppSizes.borderHairline,
                  ),
                ),
                child: Center(child: content),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
