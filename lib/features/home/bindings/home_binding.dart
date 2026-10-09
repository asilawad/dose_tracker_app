import 'package:dose_tracker/features/home/controllers/home_controller.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:get/get.dart';

/// Provides the [HomeController] for the Home tab. It is run by
/// `MainShellBinding`, because the tab lives inside the main shell.
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(Get.find<ProfilesRepository>()),
    );
  }
}
