import 'package:dose_tracker/features/shell/controllers/main_shell_controller.dart';
import 'package:get/get.dart';

/// Provides the [MainShellController] when the shell route opens.
///
/// Each tab's own binding is added in the step that creates that tab.
class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainShellController>(MainShellController.new);
  }
}
