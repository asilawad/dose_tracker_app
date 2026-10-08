import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:drift/drift.dart';

/// Local data source for medications: every database query for the
/// medications table lives here.
///
/// Every method takes the [accountId] and filters by it, so no query can read
/// or change another account's medications. Dose times are handled by their
/// own data source, and the repository combines the two.
class MedicationsLocalDataSource {
  const MedicationsLocalDataSource(this._db);

  final AppDatabase _db;

  /// Live list of one profile's medications, oldest first.
  Stream<List<MedicationRow>> watchByProfile({
    required int accountId,
    required int profileId,
  }) {
    return (_db.select(_db.medications)
          ..where(
            (t) =>
                t.accountId.equals(accountId) & t.profileId.equals(profileId),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  /// Live list of every medication in the account, oldest first.
  Stream<List<MedicationRow>> watchByAccount(int accountId) {
    return (_db.select(_db.medications)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  Future<MedicationRow?> findById({required int accountId, required int id}) {
    return (_db.select(_db.medications)
          ..where((t) => t.accountId.equals(accountId) & t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Returns the new medication id.
  Future<int> insert({
    required int accountId,
    required int profileId,
    required String name,
    required double doseAmount,
    required DoseUnit doseUnit,
    required MealInstruction? mealInstruction,
    required bool trackInventory,
    required int? stockTotal,
    required int? stockRemaining,
  }) {
    return _db
        .into(_db.medications)
        .insert(
          MedicationsCompanion.insert(
            accountId: accountId,
            profileId: profileId,
            name: name,
            doseAmount: doseAmount,
            doseUnit: doseUnit,
            mealInstruction: Value<MealInstruction?>(mealInstruction),
            trackInventory: Value<bool>(trackInventory),
            stockTotal: Value<int?>(stockTotal),
            stockRemaining: Value<int?>(stockRemaining),
          ),
        );
  }

  /// Returns how many rows changed (0 when the medication is not in this
  /// account).
  Future<int> updateDetails({
    required int accountId,
    required int id,
    required int profileId,
    required String name,
    required double doseAmount,
    required DoseUnit doseUnit,
    required MealInstruction? mealInstruction,
    required bool trackInventory,
  }) {
    return (_db.update(
      _db.medications,
    )..where((t) => t.accountId.equals(accountId) & t.id.equals(id))).write(
      MedicationsCompanion(
        profileId: Value<int>(profileId),
        name: Value<String>(name),
        doseAmount: Value<double>(doseAmount),
        doseUnit: Value<DoseUnit>(doseUnit),
        mealInstruction: Value<MealInstruction?>(mealInstruction),
        trackInventory: Value<bool>(trackInventory),
      ),
    );
  }

  /// Sets the stock after a refill or a taken dose. [stockTotal] changes only
  /// on a refill, so pass the existing value when just decrementing.
  Future<int> updateStock({
    required int accountId,
    required int id,
    required int? stockTotal,
    required int? stockRemaining,
  }) {
    return (_db.update(
      _db.medications,
    )..where((t) => t.accountId.equals(accountId) & t.id.equals(id))).write(
      MedicationsCompanion(
        stockTotal: Value<int?>(stockTotal),
        stockRemaining: Value<int?>(stockRemaining),
      ),
    );
  }

  /// Pauses or resumes a medication without deleting its history.
  Future<int> setActive({
    required int accountId,
    required int id,
    required bool isActive,
  }) {
    return (_db.update(_db.medications)
          ..where((t) => t.accountId.equals(accountId) & t.id.equals(id)))
        .write(MedicationsCompanion(isActive: Value<bool>(isActive)));
  }

  /// Also deletes the medication's dose times and history (cascade).
  /// Returns how many rows were deleted.
  Future<int> deleteById({required int accountId, required int id}) {
    return (_db.delete(
      _db.medications,
    )..where((t) => t.accountId.equals(accountId) & t.id.equals(id))).go();
  }
}
