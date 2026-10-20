import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/medications_local_data_source.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:dose_tracker/core/utils/stock_policy.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/data/models/medication_results.dart';
import 'package:dose_tracker/features/medications/data/repositories/medication_mapper.dart';

/// Changes to a medication that already exists: refilling its stock and
/// pausing or resuming it. Creating and reading medications stays in
/// `MedicationsRepository`.
///
/// It always works on the logged-in account (the id comes from the session)
/// and every query is filtered by it. Call it only after login.
class MedicationUpdatesRepository {
  const MedicationUpdatesRepository({
    required AppDatabase database,
    required MedicationsLocalDataSource medications,
    required DoseTimesLocalDataSource doseTimes,
    required SessionService session,
  }) : _database = database,
       _medications = medications,
       _doseTimes = doseTimes,
       _session = session;

  final AppDatabase _database;
  final MedicationsLocalDataSource _medications;
  final DoseTimesLocalDataSource _doseTimes;
  final SessionService _session;

  Future<UpdateMedicationResult> updateMedication({
    required int medicationId,
    required String name,
    required double doseAmount,
    required DoseUnit doseUnit,
    required MealInstruction? mealInstruction,
    required List<DoseTimeInput> times,
    required bool trackInventory,
    int? currentStock,
    int stockThreshold = StockPolicy.defaultThreshold,
  }) async {
    final int accountId = _session.requireActiveAccountId();
    if (!MedicationMapper.isValidSchedule(times)) {
      return const UpdateMedicationInvalidSchedule();
    }
    if (trackInventory &&
        (currentStock == null || currentStock <= 0 || stockThreshold <= 0)) {
      return const UpdateMedicationInvalidStock();
    }

    return _database.transaction<UpdateMedicationResult>(() async {
      final MedicationRow? row = await _medications.findById(
        accountId: accountId,
        id: medicationId,
      );
      if (row == null) {
        return const UpdateMedicationNotFound();
      }
      await _medications.updateDetails(
        accountId: accountId,
        id: medicationId,
        profileId: row.profileId,
        name: name.trim(),
        doseAmount: doseAmount,
        doseUnit: doseUnit,
        mealInstruction: mealInstruction,
        trackInventory: trackInventory,
      );
      await _medications.updateInventory(
        accountId: accountId,
        id: medicationId,
        trackInventory: trackInventory,
        stockRemaining: currentStock,
        stockThreshold: trackInventory ? stockThreshold : null,
      );
      await _doseTimes.replaceForMedication(
        accountId: accountId,
        medicationId: medicationId,
        times: times,
      );
      return const UpdateMedicationSuccess();
    });
  }

  /// Records a refill: [newStock] is the count on hand after refilling. It
  /// becomes the remaining stock.
  Future<RestockResult> restock({
    required int medicationId,
    required int newStock,
  }) async {
    final int accountId = _session.requireActiveAccountId();

    if (newStock <= 0) {
      return const RestockInvalidAmount();
    }
    final MedicationRow? row = await _medications.findById(
      accountId: accountId,
      id: medicationId,
    );
    if (row == null) {
      return const RestockNotFound();
    }
    if (!row.trackInventory) {
      return const RestockNotTracked();
    }

    await _medications.updateStock(
      accountId: accountId,
      id: medicationId,
      stockRemaining: newStock,
    );
    return const RestockSuccess();
  }

  /// Pauses ([isActive] false) or resumes a medication. A paused medication
  /// has no doses in the schedule; its history stays.
  Future<SetActiveResult> setActive({
    required int medicationId,
    required bool isActive,
  }) async {
    final int accountId = _session.requireActiveAccountId();

    final MedicationRow? row = await _medications.findById(
      accountId: accountId,
      id: medicationId,
    );
    if (row == null) {
      return const SetActiveNotFound();
    }
    await _medications.setActive(
      accountId: accountId,
      id: medicationId,
      isActive: isActive,
    );
    return const SetActiveSuccess();
  }
}
