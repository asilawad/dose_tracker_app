import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The list inside the "who is this for" bottom sheet: one row per family
/// member, with a check on the chosen one.
///
/// Choosing a row selects that profile and closes the sheet. The controller
/// comes from `AddMedicationBinding`.
class ProfilePickerSheetContent extends GetView<AddMedicationController> {
  const ProfilePickerSheetContent({super.key});

  void _select(int id) {
    controller.selectProfile(id);
    Get.back<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int? selectedId = controller.selectedProfileId.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final Profile profile in controller.profiles)
            _ProfileOption(
              profile: profile,
              selected: profile.id == selectedId,
              onTap: () => _select(profile.id),
            ),
        ],
      );
    });
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
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
    final TextStyle style = Theme.of(context).textTheme.bodyLarge!;

    return Semantics(
      button: true,
      selected: selected,
      label: profile.name,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spaceXs),
              child: Row(
                children: <Widget>[
                  PersonaAvatar(
                    persona: profile.personaColor,
                    size: PersonaAvatarSize.small,
                  ),
                  const SizedBox(width: AppSizes.spaceMd),
                  Expanded(
                    child: Text(
                      profile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: style.copyWith(
                        color: selected ? colors.active : null,
                      ),
                    ),
                  ),
                  if (selected)
                    Icon(
                      Icons.check_rounded,
                      size: AppSizes.iconLg,
                      color: colors.active,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
