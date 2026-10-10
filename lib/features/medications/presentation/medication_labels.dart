import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';

/// The translation key of each dose unit, so every screen shows the same
/// label. Translate it with `.tr` where it is shown.
extension DoseUnitLabel on DoseUnit {
  String get labelKey {
    return switch (this) {
      DoseUnit.mg => AppStrings.medsUnitMg,
      DoseUnit.iu => AppStrings.medsUnitIu,
      DoseUnit.ml => AppStrings.medsUnitMl,
      DoseUnit.pills => AppStrings.medsUnitPills,
    };
  }
}

/// The translation key of each meal instruction.
extension MealInstructionLabel on MealInstruction {
  String get labelKey {
    return switch (this) {
      MealInstruction.beforeMeal => AppStrings.medsMealBefore,
      MealInstruction.withMeal => AppStrings.medsMealWith,
      MealInstruction.afterMeal => AppStrings.medsMealAfter,
    };
  }
}
