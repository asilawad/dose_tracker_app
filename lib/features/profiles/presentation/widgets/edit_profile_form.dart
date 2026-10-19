import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/profiles/controllers/edit_profile_controller.dart';
import 'package:dose_tracker/features/profiles/data/models/profile_avatar.dart';
import 'package:dose_tracker/features/profiles/presentation/widgets/avatar_picker.dart';
import 'package:dose_tracker/features/profiles/presentation/widgets/persona_color_picker.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Edit Profile card: a live avatar preview, the identity color picker,
/// the name field and the Save button.
///
/// State comes from [EditProfileController]. The avatar takes the chosen
/// color right away, pressing "done" on the keyboard saves, and the button
/// shows a spinner while saving.
class EditProfileForm extends GetView<EditProfileController> {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Form(
      key: controller.formKey,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller.nameController,
                builder: (BuildContext context, TextEditingValue value, _) =>
                    Obx(
                      () => PersonaAvatar(
                        persona: controller.selectedColor.value,
                        size: PersonaAvatarSize.extraLarge,
                        avatar: controller.avatar.value,
                        name: value.text,
                      ),
                    ),
              ),
            ),
            const SizedBox(height: AppSizes.spaceLg),
            Text(
              AppStrings.profileAvatarLabel.tr,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSizes.spaceMd),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller.nameController,
              builder: (BuildContext context, TextEditingValue value, _) => Obx(
                () => AvatarPicker(
                  name: value.text,
                  persona: controller.selectedColor.value,
                  selected: controller.avatar.value,
                  onChanged: (ProfileAvatar? avatar) =>
                      controller.avatar.value = avatar,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.space2xl),
            Text(
              AppStrings.profilesColorLabel.tr,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSizes.spaceMd),
            Obx(
              () => PersonaColorPicker(
                selected: controller.selectedColor.value,
                onChanged: controller.selectColor,
              ),
            ),
            const SizedBox(height: AppSizes.space2xl),
            AppTextField(
              label: AppStrings.profilesNameLabel.tr,
              hint: AppStrings.profilesNameHint.tr,
              controller: controller.nameController,
              prefixIcon: Icons.badge_outlined,
              textInputAction: TextInputAction.done,
              validator: controller.validateName,
              onSubmitted: (_) => controller.submit(),
            ),
            const SizedBox(height: AppSizes.space2xl),
            Obx(
              () => GradientButton(
                label: AppStrings.actionSave.tr,
                isLoading: controller.isLoading.value,
                onPressed: controller.submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
