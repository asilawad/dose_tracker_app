import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/features/medications/data/models/medication_results.dart';
import 'package:get/get.dart';

abstract final class MedicationFormResultHandler {
  static bool handleAdd(AddMedicationResult result) {
    switch (result) {
      case AddMedicationSuccess():
        Get.back<void>();
        AppSnackbar.success(AppStrings.medsSaved.tr);
        return true;
      case AddMedicationProfileNotFound():
        AppSnackbar.error(AppStrings.medsErrorProfileNotFound.tr);
        return false;
      case AddMedicationInvalidSchedule():
        AppSnackbar.error(AppStrings.medsErrorInvalidSchedule.tr);
        return false;
      case AddMedicationInvalidStock():
        AppSnackbar.error(AppStrings.medsErrorInvalidStock.tr);
        return false;
    }
  }

  static bool handleUpdate(UpdateMedicationResult result) {
    switch (result) {
      case UpdateMedicationSuccess():
        Get.back<void>();
        AppSnackbar.success(AppStrings.medsUpdated.tr);
        return true;
      case UpdateMedicationNotFound():
        AppSnackbar.error(AppStrings.medsErrorMedicationNotFound.tr);
        return false;
      case UpdateMedicationInvalidSchedule():
        AppSnackbar.error(AppStrings.medsErrorInvalidSchedule.tr);
        return false;
      case UpdateMedicationInvalidStock():
        AppSnackbar.error(AppStrings.medsErrorInvalidStock.tr);
        return false;
    }
  }
}
