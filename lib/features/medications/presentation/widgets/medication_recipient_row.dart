import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/app_shadows.dart';
import 'package:dose_tracker/features/medications/controllers/medication_form_controller.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicationRecipientRow extends GetView<MedicationFormController> {
  const MedicationRecipientRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Profile? profile = controller.profile.value;
      if (profile == null) {
        return const SizedBox.shrink();
      }
      final AppColorTokens colors = context.appColors;
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          height: 44,
          padding: const EdgeInsetsDirectional.fromSTEB(6, 0, 16, 0),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusChip),
            boxShadow: AppShadows.soft(colors),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              PersonaAvatar(
                persona: profile.personaColor,
                size: PersonaAvatarSize.extraSmall,
                avatar: profile.avatar,
                name: profile.name,
              ),
              const SizedBox(width: AppSizes.spaceSm),
              Flexible(
                child: Text(
                  profile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
