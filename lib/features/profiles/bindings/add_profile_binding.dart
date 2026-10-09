import 'package:dose_tracker/features/profiles/controllers/add_profile_controller.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:get/get.dart';

/// Provides the [AddProfileController] when the Add Profile route opens and
/// removes it when the route closes. [ProfilesRepository] is registered
/// app-wide in `InitialBinding`.
class AddProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddProfileController>(
      () => AddProfileController(Get.find<ProfilesRepository>()),
    );
  }
}
