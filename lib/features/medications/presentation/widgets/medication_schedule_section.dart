import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_frequency_row.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_times_list.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:flutter/material.dart';

class MedicationScheduleSection extends StatelessWidget {
  const MedicationScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MedicationFrequencyRow(),
          SizedBox(height: AppSizes.spaceMd),
          MedicationTimesList(),
        ],
      ),
    );
  }
}
