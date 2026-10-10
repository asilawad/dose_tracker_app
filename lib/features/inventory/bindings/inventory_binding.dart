import 'package:dose_tracker/features/inventory/controllers/inventory_controller.dart';
import 'package:dose_tracker/features/inventory/data/repositories/inventory_repository.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:get/get.dart';

/// Provides the [InventoryController] for the Inventory tab. It is run by
/// `MainShellBinding`, because the tab lives inside the main shell.
class InventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryController>(
      () => InventoryController(
        Get.find<InventoryRepository>(),
        Get.find<MedicationsRepository>(),
      ),
    );
  }
}
