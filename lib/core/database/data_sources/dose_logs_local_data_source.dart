import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_status.dart';
import 'package:drift/drift.dart';

/// Local data source for dose logs: every database query for the dose_logs
/// table lives here.
///
/// A log row is the recorded outcome of one scheduled dose on one day; no row
/// means the dose is still pending. Every method takes the [accountId] and
/// filters by it, so no query can read or change another account's history.
class DoseLogsLocalDataSource {
  const DoseLogsLocalDataSource(this._db);

  final AppDatabase _db;

  /// Live list of logs whose scheduled date falls in [from]..[to] (both
  /// inclusive, local midnight values). Pass [profileId] to limit the result
  /// to one family member, which the adherence calendar needs because
  /// profiles are never combined.
  Stream<List<DoseLogRow>> watchByDateRange({
    required int accountId,
    required DateTime from,
    required DateTime to,
    int? profileId,
  }) {
    return (_db.select(_db.doseLogs)
          ..where((t) {
            Expression<bool> condition =
                t.accountId.equals(accountId) &
                t.scheduledDate.isBetweenValues(from, to);
            if (profileId != null) {
              condition = condition & t.profileId.equals(profileId);
            }
            return condition;
          })
          ..orderBy([
            (t) => OrderingTerm.asc(t.scheduledDate),
            (t) => OrderingTerm.asc(t.scheduledMinuteOfDay),
          ]))
        .watch();
  }

  /// Saves the outcome of a dose. If that dose already has a log (same
  /// medication, date and time), the old row is replaced in the same
  /// transaction, so changing "skipped" to "taken" never leaves two rows.
  /// Returns the new log id.
  Future<int> upsert({
    required int accountId,
    required int profileId,
    required int medicationId,
    required int? doseTimeId,
    required DateTime scheduledDate,
    required int scheduledMinuteOfDay,
    required double quantity,
    required DoseStatus status,
    required DateTime? takenAt,
    required String? skipReason,
  }) {
    return _db.transaction(() async {
      await (_db.delete(_db.doseLogs)..where(
            (t) =>
                t.accountId.equals(accountId) &
                t.medicationId.equals(medicationId) &
                t.scheduledDate.equals(scheduledDate) &
                t.scheduledMinuteOfDay.equals(scheduledMinuteOfDay),
          ))
          .go();

      return _db
          .into(_db.doseLogs)
          .insert(
            DoseLogsCompanion.insert(
              accountId: accountId,
              profileId: profileId,
              medicationId: medicationId,
              doseTimeId: Value<int?>(doseTimeId),
              scheduledDate: scheduledDate,
              scheduledMinuteOfDay: scheduledMinuteOfDay,
              quantity: quantity,
              status: status,
              takenAt: Value<DateTime?>(takenAt),
              skipReason: Value<String?>(skipReason),
            ),
          );
    });
  }

  /// Removes a log, which puts the dose back to pending (the "undo" action).
  /// Returns how many rows were deleted (0 when it is not in this account).
  Future<int> deleteById({required int accountId, required int id}) {
    return (_db.delete(
      _db.doseLogs,
    )..where((t) => t.accountId.equals(accountId) & t.id.equals(id))).go();
  }
}
