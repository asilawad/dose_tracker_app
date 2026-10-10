import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/profile_picker_sheet_content.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/views/widgets/app_bottom_sheet.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_text_link.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The "dose recipient" card at the top of Add Medication: the chosen
/// family member's avatar and name, with a Change link when there is more
/// than one profile to choose from.
///
/// The Change link opens a bottom sheet with the profile list. State comes
/// from [AddMedicationController].
class MedicationRecipientCard extends GetView<AddMedicationController> {
  const MedicationRecipientCard({super.key});

  void _openPicker() {
    AppBottomSheet.show<void>(
      title: AppStrings.medsRecipientSheetTitle.tr,
      child: const ProfilePickerSheetContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final Profile? profile = controller.selectedProfile;
      final bool canChange = controller.profiles.length > 1;

      return AppCard(
        child: profile == null
            ? Text(AppStrings.medsNoProfiles.tr, style: textTheme.bodyMedium)
            : Row(
                children: <Widget>[
                  PersonaAvatar(persona: profile.personaColor),
                  const SizedBox(width: AppSizes.spaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AppStrings.medsRecipientLabel.tr,
                          style: textTheme.bodyMedium,
                        ),
                        Text(
                          profile.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  if (canChange)
                    AppTextLink(
                      label: AppStrings.medsRecipientChange.tr,
                      onPressed: _openPicker,
                    ),
                ],
              ),
      );
    });
  }
}
