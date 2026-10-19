import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The "dose recipient" card at the top of Add Medication: the family
/// member's avatar and name. It is read-only, because the screen is opened
/// from that member's page. Nothing shows while the profile is loading.
/// State comes from [AddMedicationController].
class MedicationRecipientCard extends GetView<AddMedicationController> {
  const MedicationRecipientCard({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Obx(() {
      final Profile? profile = controller.profile.value;
      if (profile == null) {
        return const SizedBox.shrink();
      }
      return AppCard(
        child: Row(
          children: <Widget>[
            PersonaAvatar(
              persona: profile.personaColor,
              avatar: profile.avatar,
              name: profile.name,
            ),
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
          ],
        ),
      );
    });
  }
}
