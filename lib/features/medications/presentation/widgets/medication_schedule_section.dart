import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_frequency_row.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_times_list.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:flutter/material.dart';

class MedicationScheduleSection extends StatelessWidget {
  const MedicationScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const MedicationFrequencyRow(),
          Divider(
            height: AppSizes.space2xl,
            thickness: AppSizes.borderHairline,
            color: colors.borderHairline,
          ),
          const MedicationTimesList(),
        ],
      ),
    );
  }
}
