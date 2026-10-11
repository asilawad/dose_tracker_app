import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:dose_tracker/features/reports/controllers/report_controller.dart';
import 'package:dose_tracker/features/reports/data/repositories/pdf_report_service.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:get/get.dart';

/// Provides the [ReportController] when the Doctor's Report route opens and
/// removes it when the route closes. [ProfilesRepository] and
/// [DoseLogsRepository] are registered app-wide in `InitialBinding`.
class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(
      () => ReportController(
        Get.find<ProfilesRepository>(),
        Get.find<DoseLogsRepository>(),
        const PdfReportService(),
      ),
    );
  }
}
