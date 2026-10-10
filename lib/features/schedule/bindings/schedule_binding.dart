import 'package:dose_tracker/features/schedule/controllers/schedule_controller.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:get/get.dart';

/// Provides the [ScheduleController] for the Schedule tab. It is run by
/// `MainShellBinding`, because the tab lives inside the main shell.
class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleController>(
      () => ScheduleController(Get.find<DoseLogsRepository>()),
    );
  }
}
