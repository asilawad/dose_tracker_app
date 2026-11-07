import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/app_shadows.dart';
import 'package:dose_tracker/features/profiles/controllers/add_profile_controller.dart';
import 'package:dose_tracker/features/profiles/data/models/profile_avatar.dart';
import 'package:dose_tracker/features/profiles/presentation/widgets/avatar_picker.dart';
import 'package:dose_tracker/features/profiles/presentation/widgets/persona_color_picker.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Add Profile card: a live avatar preview, the identity color picker,
/// the name field and the Save button.
///
/// State comes from [AddProfileController]. The avatar takes the chosen
/// color right away, pressing "done" on the keyboard saves, and the button
/// shows a spinner while saving.
class AddProfileForm extends GetView<AddProfileController> {
  const AddProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextStyle? label = Theme.of(context).textTheme.titleSmall;

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.nameController,
            builder: (BuildContext context, TextEditingValue value, _) => Obx(
              () => Column(
                children: <Widget>[
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.surface, width: 6),
                      boxShadow: AppShadows.soft(colors),
                    ),
                    child: PersonaAvatar(
                      persona: controller.selectedColor.value,
                      size: PersonaAvatarSize.extraLarge,
                      avatar: controller.avatar.value,
                      name: value.text,
                    ),
                  ),
                  const SizedBox(height: AppSizes.gutter),
                  Text(
                    value.text.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(AppStrings.profileAvatarLabel.tr, style: label),
                const SizedBox(height: AppSizes.spaceSm),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller.nameController,
                  builder: (BuildContext context, TextEditingValue value, _) =>
                      Obx(
                        () => AvatarPicker(
                          name: value.text,
                          persona: controller.selectedColor.value,
                          selected: controller.avatar.value,
                          onChanged: (ProfileAvatar? avatar) =>
                              controller.avatar.value = avatar,
                        ),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.gutter),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(AppStrings.profilesColorLabel.tr, style: label),
                const SizedBox(height: AppSizes.spaceSm),
                Obx(
                  () => PersonaColorPicker(
                    selected: controller.selectedColor.value,
                    onChanged: controller.selectColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.gutter),
          AppCard(
            child: AppTextField(
              label: AppStrings.profilesNameLabel.tr,
              hint: AppStrings.profilesNameHint.tr,
              controller: controller.nameController,
              prefixIcon: Icons.badge_rounded,
              textInputAction: TextInputAction.done,
              validator: controller.validateName,
              onSubmitted: (_) => controller.submit(),
            ),
          ),
        ],
      ),
    );
  }
}
