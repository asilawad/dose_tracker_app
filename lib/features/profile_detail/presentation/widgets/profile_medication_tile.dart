import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/data/models/dose_time.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/pill_tile.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:dose_tracker/views/widgets/time_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One medication on the profile page: tinted icon, name, dose and meal,
/// its daily times as chips, and a "Paused" badge when it is not active.
class ProfileMedicationTile extends StatelessWidget {
  const ProfileMedicationTile({
    required this.medication,
    required this.persona,
    required this.onTap,
    super.key,
  });

  final Medication medication;
  final PersonaColor persona;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String? meal = medication.mealInstruction?.labelKey.tr;
    final String subtitle = <String>[
      '${DoseFormatter.quantity(medication.doseAmount)} '
          '${medication.doseUnit.labelKey.tr}',
      ?meal,
    ].join(' \u00B7 ');

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              PillTile(persona: persona),
              const SizedBox(width: AppSizes.gutter),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      medication.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.headlineSmall,
                    ),
                    Text(subtitle, style: textTheme.bodyMedium),
                  ],
                ),
              ),
              if (!medication.isActive) ...<Widget>[
                const SizedBox(width: AppSizes.spaceSm),
                StatusBadge(
                  label: AppStrings.inventoryPaused.tr,
                  tone: BadgeTone.active,
                ),
              ],
              const SizedBox(width: AppSizes.spaceSm),
              Icon(
                Icons.edit_rounded,
                size: AppSizes.iconMd,
                color: colors.textTertiary,
              ),
            ],
          ),
          if (medication.doseTimes.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSizes.gutter),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: <Widget>[
                for (final DoseTime time in medication.doseTimes)
                  TimeChip(label: DoseFormatter.minuteOfDay(time.minuteOfDay)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
