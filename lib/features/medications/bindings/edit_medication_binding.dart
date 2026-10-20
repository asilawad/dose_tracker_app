import 'package:dose_tracker/features/medications/controllers/medication_form_controller.dart';
import 'package:dose_tracker/features/medications/data/repositories/medication_updates_repository.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:get/get.dart';

class EditMedicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicationFormController>(() {
      final Object? arguments = Get.arguments;
      return MedicationFormController(
        Get.find<ProfilesRepository>(),
        Get.find<MedicationsRepository>(),
        Get.find<MedicationUpdatesRepository>(),
        medicationId: arguments is int ? arguments : null,
      );
    });
  }
}
