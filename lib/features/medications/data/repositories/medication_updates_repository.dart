import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/medications_local_data_source.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:dose_tracker/features/medications/data/models/medication_results.dart';

/// Changes to a medication that already exists: refilling its stock and
/// pausing or resuming it. Creating and reading medications stays in
/// `MedicationsRepository`.
///
/// It always works on the logged-in account (the id comes from the session)
/// and every query is filtered by it. Call it only after login.
class MedicationUpdatesRepository {
  const MedicationUpdatesRepository({
    required MedicationsLocalDataSource medications,
    required SessionService session,
  }) : _medications = medications,
       _session = session;

  final MedicationsLocalDataSource _medications;
  final SessionService _session;

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
