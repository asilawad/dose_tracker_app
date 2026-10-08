import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:drift/drift.dart';

/// Local data source: the class that holds every database query for
/// one table. This one handles family profiles (Me, Mom, Dad, anyone).
///
/// Every method takes the [accountId] and filters by it. That is the account
/// isolation rule: no query can read or change another account's profiles,
/// even by guessing an id.
class ProfilesLocalDataSource {
  const ProfilesLocalDataSource(this._db);

  final AppDatabase _db;

  /// Live list of the account's profiles, oldest first. Emits again whenever
  /// a profile is added, edited or deleted.
  Stream<List<ProfileRow>> watchByAccount(int accountId) {
    return (_db.select(_db.profiles)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .watch();
  }

  Future<ProfileRow?> findById({required int accountId, required int id}) {
    return (_db.select(_db.profiles)
          ..where((t) => t.accountId.equals(accountId) & t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Returns the new profile id.
  Future<int> insert({
    required int accountId,
    required String name,
    required PersonaColor personaColor,
    required bool remindersEnabled,
  }) {
    return _db
        .into(_db.profiles)
        .insert(
          ProfilesCompanion.insert(
            accountId: accountId,
            name: name,
            personaColor: personaColor,
            remindersEnabled: Value<bool>(remindersEnabled),
          ),
        );
  }

  /// Returns how many rows changed (0 when the profile is not in this account).
  Future<int> updateDetails({
    required int accountId,
    required int id,
    required String name,
    required PersonaColor personaColor,
    required bool remindersEnabled,
  }) {
    return (_db.update(
      _db.profiles,
    )..where((t) => t.accountId.equals(accountId) & t.id.equals(id))).write(
      ProfilesCompanion(
        name: Value<String>(name),
        personaColor: Value<PersonaColor>(personaColor),
        remindersEnabled: Value<bool>(remindersEnabled),
      ),
    );
  }

  /// Also deletes the profile's medications, times and history (cascade).
  /// Returns how many rows were deleted.
  Future<int> deleteById({required int accountId, required int id}) {
    return (_db.delete(
      _db.profiles,
    )..where((t) => t.accountId.equals(accountId) & t.id.equals(id))).go();
  }
}
