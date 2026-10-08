import 'package:dose_tracker/core/database/tables/accounts_table.dart';
import 'package:dose_tracker/core/database/tables/profiles_table.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:drift/drift.dart';

/// A medication or supplement assigned to one family profile.
///
/// [accountId] is stored on every row (not only through the profile) so any
/// query can filter by account directly, which is the isolation rule.
/// [doseAmount] and [doseUnit] are the strength, for example 500 mg. How many
/// tablets are taken at each time is stored with the dose times, not here.
/// Inventory fields are null when [trackInventory] is false. [stockTotal] is
/// the amount at the last refill, and the fixed 10% low-stock alert is
/// computed from it. Deleting a profile or account deletes its medications.
/// The name length limit is checked by form validation, not the table.
@DataClassName('MedicationRow')
class Medications extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();

  IntColumn get profileId =>
      integer().references(Profiles, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text()();

  RealColumn get doseAmount => real()();

  TextColumn get doseUnit => textEnum<DoseUnit>()();

  TextColumn get mealInstruction => textEnum<MealInstruction>().nullable()();

  BoolColumn get trackInventory =>
      boolean().withDefault(const Constant(false))();

  IntColumn get stockTotal => integer().nullable()();

  IntColumn get stockRemaining => integer().nullable()();

  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
