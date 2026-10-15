import 'package:dose_tracker/core/database/tables/accounts_table.dart';
import 'package:dose_tracker/core/database/tables/dose_logs_table.dart';
import 'package:dose_tracker/core/database/tables/dose_times_table.dart';
import 'package:dose_tracker/core/database/tables/medications_table.dart';
import 'package:dose_tracker/core/database/tables/profiles_table.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_status.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// The single local SQLite database for the whole app.
///
/// Accounts are isolated by an `accountId` column on every table, and all
/// reads and writes go through DAOs that always filter by it. The enum
/// imports above are needed by the generated `app_database.g.dart`.
///
/// Changing any table means: raise [currentSchemaVersion], add a step to
/// `onUpgrade`, then regenerate with
/// `dart run build_runner build --delete-conflicting-outputs`.
@DriftDatabase(
  tables: <Type>[Accounts, Profiles, Medications, DoseTimes, DoseLogs],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: fileName));

  /// For tests: pass an in-memory executor.
  AppDatabase.forTesting(super.executor);

  /// Database file name (the platform adds its own extension and folder).
  static const String fileName = 'dose_tracker';

  static const int currentSchemaVersion = 2;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator migrator) => migrator.createAll(),
    onUpgrade: (Migrator migrator, int from, int to) async {
      if (from < 2) {
        // Version 2: the refill alert level replaces the stock total. Old
        // medications keep their old 10% rule (at least 1).
        await migrator.addColumn(medications, medications.stockThreshold);
        await customStatement(
          'UPDATE medications '
          'SET stock_threshold = MAX(1, stock_total / 10) '
          'WHERE track_inventory = 1 AND stock_total IS NOT NULL',
        );
        await migrator.dropColumn(medications, 'stock_total');
      }
    },
    beforeOpen: (OpeningDetails details) async {
      // SQLite ignores foreign keys unless enabled on every connection.
      // Cascading deletes (account -> profiles -> medications) rely on it.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
