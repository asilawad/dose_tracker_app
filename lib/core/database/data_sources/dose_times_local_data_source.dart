import 'package:dose_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart';

/// One scheduled intake time to save: minutes after local midnight (0 to
/// 1439) and the amount taken at that time (can be fractional, for example
/// 0.5 tablet).
typedef DoseTimeInput = ({int minuteOfDay, double quantity});

/// Local data source for medication dose times: every database query for the
/// dose_times table lives here.
///
/// Every method takes the [accountId] and filters by it, so no query can read
/// or change another account's schedule.
class DoseTimesLocalDataSource {
  const DoseTimesLocalDataSource(this._db);

  final AppDatabase _db;

  /// Live list of every dose time in the account, earliest time of day first.
  /// The daily schedule is built from this together with the medications.
  Stream<List<DoseTimeRow>> watchByAccount(int accountId) {
    return (_db.select(_db.doseTimes)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.minuteOfDay),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .watch();
  }

  /// The times of one medication, earliest first.
  Future<List<DoseTimeRow>> findByMedication({
    required int accountId,
    required int medicationId,
  }) {
    return (_db.select(_db.doseTimes)
          ..where(
            (t) =>
                t.accountId.equals(accountId) &
                t.medicationId.equals(medicationId),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.minuteOfDay)]))
        .get();
  }

  /// Replaces a medication's whole schedule in one transaction, so an edit
  /// can never leave it half old and half new. Used for both the first save
  /// and later edits. Past logs keep their own copy of the time, so they are
  /// not affected.
  Future<void> replaceForMedication({
    required int accountId,
    required int medicationId,
    required List<DoseTimeInput> times,
  }) {
    return _db.transaction(() async {
      await (_db.delete(_db.doseTimes)..where(
            (t) =>
                t.accountId.equals(accountId) &
                t.medicationId.equals(medicationId),
          ))
          .go();

      await _db.batch((Batch batch) {
        batch.insertAll(
          _db.doseTimes,
          times.map(
            (DoseTimeInput time) => DoseTimesCompanion.insert(
              accountId: accountId,
              medicationId: medicationId,
              minuteOfDay: time.minuteOfDay,
              quantity: Value<double>(time.quantity),
            ),
          ),
        );
      });
    });
  }
}
