import 'package:dose_tracker/core/database/tables/accounts_table.dart';
import 'package:dose_tracker/core/database/tables/dose_times_table.dart';
import 'package:dose_tracker/core/database/tables/medications_table.dart';
import 'package:dose_tracker/core/database/tables/profiles_table.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_status.dart';
import 'package:drift/drift.dart';

/// The recorded outcome of one scheduled dose on one day. No row means the
/// dose is still pending, so this table only holds actions and missed doses.
///
/// [scheduledMinuteOfDay] and [quantity] are copied from the dose time when
/// the log is written, so history stays correct after the schedule is
/// edited. [doseTimeId] is therefore nullable and becomes null if that time
/// is deleted. [scheduledDate] is always local midnight of the day, set by
/// the repository. A dose can be logged only once per day: the unique key is
/// medication, date and minute. [takenAt] is set for taken and late doses.
/// [skipReason] is free text for skipped doses. [accountId] and [profileId]
/// are stored here so adherence queries filter without joins. Deleting a
/// medication, profile or account also deletes its history.
@DataClassName('DoseLogRow')
class DoseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();

  IntColumn get profileId =>
      integer().references(Profiles, #id, onDelete: KeyAction.cascade)();

  IntColumn get medicationId =>
      integer().references(Medications, #id, onDelete: KeyAction.cascade)();

  IntColumn get doseTimeId => integer().nullable().references(
    DoseTimes,
    #id,
    onDelete: KeyAction.setNull,
  )();

  DateTimeColumn get scheduledDate => dateTime()();

  IntColumn get scheduledMinuteOfDay => integer()();

  RealColumn get quantity => real()();

  TextColumn get status => textEnum<DoseStatus>()();

  DateTimeColumn get takenAt => dateTime().nullable()();

  TextColumn get skipReason => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => <Set<Column<Object>>>[
    <Column<Object>>{medicationId, scheduledDate, scheduledMinuteOfDay},
  ];
}
