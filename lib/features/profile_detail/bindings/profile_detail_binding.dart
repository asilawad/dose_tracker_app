import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profile_detail/controllers/profile_detail_controller.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:get/get.dart';

/// Provides the [ProfileDetailController] when the profile route opens. The
/// route's `arguments` is the profile id (an int); anything else is treated
/// as "no profile".
class ProfileDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileDetailController>(() {
      final Object? arguments = Get.arguments;
      return ProfileDetailController(
        Get.find<ProfilesRepository>(),
        Get.find<MedicationsRepository>(),
        Get.find<DoseLogsRepository>(),
        arguments is int ? arguments : null,
      );
    });
  }
}
