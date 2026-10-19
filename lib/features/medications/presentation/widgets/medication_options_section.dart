import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_inventory_options.dart';
import 'package:dose_tracker/features/medications/presentation/widgets/medication_meal_options.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicationOptionsSection extends StatelessWidget {
  const MedicationOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return AppCard(
      child: ExpansionTile(
        title: Text(AppStrings.medsMoreOptions.tr),
        maintainState: true,
        initiallyExpanded: false,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        collapsedShape: const Border(),
        shape: const Border(),
        children: <Widget>[
          const SizedBox(height: AppSizes.spaceMd),
          const MedicationMealOptions(),
          Divider(
            height: AppSizes.space2xl,
            thickness: AppSizes.borderHairline,
            color: colors.borderHairline,
          ),
          const MedicationInventoryOptions(),
        ],
      ),
    );
  }
}
