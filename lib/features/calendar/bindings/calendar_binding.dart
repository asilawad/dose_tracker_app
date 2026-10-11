import 'package:dose_tracker/features/calendar/controllers/calendar_controller.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:get/get.dart';

/// Provides the [CalendarController] when the Adherence Calendar route
/// opens and removes it when the route closes. [ProfilesRepository] and
/// [DoseLogsRepository] are registered app-wide in `InitialBinding`.
class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarController>(
      () => CalendarController(
        Get.find<ProfilesRepository>(),
        Get.find<DoseLogsRepository>(),
      ),
    );
  }
}
