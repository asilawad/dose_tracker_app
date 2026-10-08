import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/database/tables/accounts_table.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:drift/drift.dart';

/// Family member profiles (Me, Mom, Dad, anyone).
///
/// A profile belongs to exactly one account, and an account can have zero,
/// one or many profiles. Deleting an account deletes its profiles (needs
/// foreign keys enabled, which the database class does on open). The name is
/// free text and the color is the user's own pick, stored by enum name so
/// theme colors can change without touching saved data.
@DataClassName('ProfileRow')
class Profiles extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text().withLength(
    min: AppSizes.nameMinLength,
    max: AppSizes.nameMaxLength,
  )();

  TextColumn get personaColor => textEnum<PersonaColor>()();

  BoolColumn get remindersEnabled =>
      boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
