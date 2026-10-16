import 'package:dose_tracker/features/medications/controllers/add_medication_controller.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:get/get.dart';

/// Provides the [AddMedicationController] when the Add Medication route
/// opens and removes it when the route closes. The route's `arguments` is
/// the id (an int) of the profile the medication is for; anything else is
/// treated as "no profile". [MedicationsRepository] and [ProfilesRepository]
/// are registered app-wide in `InitialBinding`.
class AddMedicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMedicationController>(() {
      final Object? arguments = Get.arguments;
      return AddMedicationController(
        Get.find<ProfilesRepository>(),
        Get.find<MedicationsRepository>(),
        arguments is int ? arguments : null,
      );
    });
  }
}
