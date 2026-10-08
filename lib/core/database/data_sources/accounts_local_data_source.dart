import 'package:dose_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart';

/// Database access for accounts: the root that every other table belongs to.
///
/// The email must already be lowercase and trimmed by the repository, and it
/// must check [findByEmail] before [insert], because the unique constraint
/// would otherwise throw a raw database error. Passwords and answers arrive
/// here already hashed. Plain classes like this one need no code generation,
/// so adding a data source never requires re-running `build_runner`.
class AccountsLocalDataSource {
  const AccountsLocalDataSource(this._db);

  final AppDatabase _db;

  Future<AccountRow?> findById(int id) {
    return (_db.select(
      _db.accounts,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<AccountRow?> findByEmail(String email) {
    return (_db.select(
      _db.accounts,
    )..where((t) => t.email.equals(email))).getSingleOrNull();
  }

  /// Returns the new account id.
  Future<int> insert({
    required String name,
    required String email,
    required String passwordHash,
    required String passwordSalt,
    required String securityQuestionKey,
    required String securityAnswerHash,
    required String securityAnswerSalt,
  }) {
    return _db
        .into(_db.accounts)
        .insert(
          AccountsCompanion.insert(
            name: name,
            email: email,
            passwordHash: passwordHash,
            passwordSalt: passwordSalt,
            securityQuestionKey: securityQuestionKey,
            securityAnswerHash: securityAnswerHash,
            securityAnswerSalt: securityAnswerSalt,
          ),
        );
  }

  Future<void> updatePassword({
    required int accountId,
    required String passwordHash,
    required String passwordSalt,
  }) {
    return (_db.update(
      _db.accounts,
    )..where((t) => t.id.equals(accountId))).write(
      AccountsCompanion(
        passwordHash: Value<String>(passwordHash),
        passwordSalt: Value<String>(passwordSalt),
      ),
    );
  }
}
