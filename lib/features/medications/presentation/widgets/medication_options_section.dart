import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_inventory_options.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_meal_options.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:flutter/material.dart';

class MedicationOptionsSection extends StatelessWidget {
  const MedicationOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppCard(child: MedicationMealOptions()),
        SizedBox(height: AppSizes.gutter),
        AppCard(child: MedicationInventoryOptions()),
      ],
    );
  }
}
