import 'package:dose_tracker/features/profiles/controllers/edit_profile_controller.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:get/get.dart';

/// Provides the [EditProfileController] when the Edit Profile route opens
/// and removes it when the route closes. The route's `arguments` is the
/// profile id (an int); anything else is treated as "no profile".
/// [ProfilesRepository] is registered app-wide in `InitialBinding`.
class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() {
      final Object? arguments = Get.arguments;
      return EditProfileController(
        Get.find<ProfilesRepository>(),
        arguments is int ? arguments : null,
      );
    });
  }
}
