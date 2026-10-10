import 'package:dose_tracker/features/home/bindings/home_binding.dart';
import 'package:dose_tracker/features/inventory/bindings/inventory_binding.dart';
import 'package:dose_tracker/features/schedule/bindings/schedule_binding.dart';
import 'package:dose_tracker/features/settings/bindings/settings_binding.dart';
import 'package:dose_tracker/features/shell/controllers/main_shell_controller.dart';
import 'package:get/get.dart';

/// Provides the [MainShellController] when the shell route opens.
///
/// Each tab's own binding is added in the step that creates that tab.
/// It also runs each tab's own binding, so the tab controllers live and are
/// released together with the shell. A tab's binding is added here in the
/// step that creates that tab.
class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainShellController>(MainShellController.new);
    HomeBinding().dependencies();
    ScheduleBinding().dependencies();
    InventoryBinding().dependencies();
    SettingsBinding().dependencies();
  }
}
