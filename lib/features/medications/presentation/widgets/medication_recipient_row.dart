import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicationRecipientRow extends GetView<AddMedicationController> {
  const MedicationRecipientRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Profile? profile = controller.profile.value;
      if (profile == null) {
        return const SizedBox.shrink();
      }
      return Row(
        children: <Widget>[
          PersonaAvatar(
            persona: profile.personaColor,
            size: PersonaAvatarSize.small,
            avatar: profile.avatar,
            name: profile.name,
          ),
          const SizedBox(width: AppSizes.spaceMd),
          Expanded(
            child: Text(
              profile.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      );
    });
  }
}
