import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profile_detail/controllers/profile_medications_controller.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:get/get.dart';

class ProfileMedicationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileMedicationsController>(() {
      final Object? arguments = Get.arguments;
      return ProfileMedicationsController(
        Get.find<ProfilesRepository>(),
        Get.find<MedicationsRepository>(),
        arguments is int ? arguments : null,
      );
    });
  }
}
