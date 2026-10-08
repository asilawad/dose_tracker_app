import 'package:dose_tracker/core/database/tables/accounts_table.dart';
import 'package:dose_tracker/core/database/tables/medications_table.dart';
import 'package:drift/drift.dart';

/// One scheduled intake time of a medication, for example 09:00, 1 tablet.
///
/// A medication with a daily frequency of 2 has two rows. [minuteOfDay] is
/// minutes after local midnight (0 to 1439), so a schedule means the same
/// wall-clock time every day and survives time zone and daylight saving
/// changes. [quantity] is the amount taken at this time (tablets, capsules,
/// ml) and can be fractional, for example 0.5. [accountId] is stored here
/// too so any query can filter by account directly. Deleting a medication
/// deletes its times.
@DataClassName('DoseTimeRow')
class DoseTimes extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();

  IntColumn get medicationId =>
      integer().references(Medications, #id, onDelete: KeyAction.cascade)();

  IntColumn get minuteOfDay => integer()();

  RealColumn get quantity => real().withDefault(const Constant(1))();
}
