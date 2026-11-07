import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/accounts_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/dose_logs_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/medications_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/profiles_local_data_source.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/inventory/data/repositories/inventory_repository.dart';
import 'package:dose_tracker/features/medications/data/repositories/medication_updates_repository.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_logs_repository.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An in-memory app: real repositories over an in-memory SQLite database,
/// registered in GetX exactly as `InitialBinding` does, with one logged-in
/// account. Call [dispose] in `tearDown`.
class TestEnv {
  TestEnv._(this.database, this.session);

  final AppDatabase database;
  final SessionService session;
  late final int accountId;

  ProfilesRepository get profiles => Get.find<ProfilesRepository>();
  MedicationsRepository get medications => Get.find<MedicationsRepository>();
  MedicationUpdatesRepository get updates =>
      Get.find<MedicationUpdatesRepository>();
  DoseLogsRepository get doseLogs => Get.find<DoseLogsRepository>();
  InventoryRepository get inventory => Get.find<InventoryRepository>();

  static Future<TestEnv> create() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    Get.testMode = true;
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SessionService session = await SessionService.create();
    Get.put<SessionService>(session, permanent: true);
    final AppDatabase database = AppDatabase.forTesting(
      NativeDatabase.memory(),
    );
    final TestEnv env = TestEnv._(database, session);
    env._register();
    env.accountId = await AccountsLocalDataSource(database).insert(
      name: 'Tester',
      email: 'tester@example.com',
      passwordHash: 'x',
      passwordSalt: 'x',
      securityQuestionKey: 'q',
      securityAnswerHash: 'x',
      securityAnswerSalt: 'x',
    );
    await session.signIn(env.accountId);
    return env;
  }

  void _register() {
    final ProfilesLocalDataSource profiles = ProfilesLocalDataSource(database);
    final MedicationsLocalDataSource medications = MedicationsLocalDataSource(
      database,
    );
    final DoseTimesLocalDataSource doseTimes = DoseTimesLocalDataSource(
      database,
    );
    final DoseLogsLocalDataSource doseLogs = DoseLogsLocalDataSource(database);
    Get.put<AppDatabase>(database, permanent: true);
    final ProfilesRepository profilesRepository = Get.put<ProfilesRepository>(
      ProfilesRepository(profiles: profiles, session: session),
      permanent: true,
    );
    final MedicationsRepository medicationsRepository =
        Get.put<MedicationsRepository>(
          MedicationsRepository(
            database: database,
            medications: medications,
            doseTimes: doseTimes,
            profiles: profiles,
            session: session,
          ),
          permanent: true,
        );
    Get.put<MedicationUpdatesRepository>(
      MedicationUpdatesRepository(
        database: database,
        medications: medications,
        doseTimes: doseTimes,
        session: session,
      ),
      permanent: true,
    );
    Get.put<DoseLogsRepository>(
      DoseLogsRepository(
        database: database,
        doseLogs: doseLogs,
        medications: medications,
        doseTimes: doseTimes,
        medicationsRepository: medicationsRepository,
        profilesRepository: profilesRepository,
        session: session,
      ),
      permanent: true,
    );
    Get.put<InventoryRepository>(
      InventoryRepository(
        medications: medicationsRepository,
        profiles: profilesRepository,
      ),
      permanent: true,
    );
  }

  /// Adds a profile and returns its id.
  Future<int> addProfile({String name = 'Mama'}) async {
    return ProfilesLocalDataSource(database).insert(
      accountId: accountId,
      name: name,
      personaColor: PersonaColor.teal,
      avatar: null,
      remindersEnabled: true,
    );
  }

  Future<void> dispose() async {
    await database.close();
    Get.reset();
  }
}
