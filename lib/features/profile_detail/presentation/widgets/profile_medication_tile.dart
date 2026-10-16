import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/data/models/dose_time.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/presentation/medication_labels.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One medication on the profile page: name with dose, its daily times, and
/// a "Paused" badge when it is not active.
class ProfileMedicationTile extends StatelessWidget {
  const ProfileMedicationTile({required this.medication, super.key});

  final Medication medication;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String title =
        '${medication.name} ${DoseFormatter.quantity(medication.doseAmount)} '
        '${medication.doseUnit.labelKey.tr}';
    final String times = medication.doseTimes
        .map((DoseTime time) => DoseFormatter.minuteOfDay(time.minuteOfDay))
        .join(' · ');

    return AppCard(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.medication_rounded,
            size: AppSizes.iconLg,
            color: colors.textSecondary,
          ),
          const SizedBox(width: AppSizes.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium,
                ),
                Text(times, style: textTheme.bodyMedium),
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
        ],
      ),
    );
  }
}
