import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:drift/drift.dart';

/// Local login accounts. Every other table points back to one account, and
/// every query filters by it, which is what keeps accounts isolated.
///
/// Passwords and security answers are never stored in plain text: only a
/// salted hash plus its salt. The email is stored lowercase and trimmed by
/// the repository, so the unique constraint works as expected. The security
/// question is stored as a translation key chosen from a fixed list.
@DataClassName('AccountRow')
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(
    min: AppSizes.nameMinLength,
    max: AppSizes.nameMaxLength,
  )();

  TextColumn get email => text().unique()();

  TextColumn get passwordHash => text()();

  TextColumn get passwordSalt => text()();

  TextColumn get securityQuestionKey => text()();

  TextColumn get securityAnswerHash => text()();

  TextColumn get securityAnswerSalt => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
