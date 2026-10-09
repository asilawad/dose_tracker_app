import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/accounts_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/dose_logs_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/medications_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/profiles_local_data_source.dart';
import 'package:dose_tracker/core/services/password_hasher.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:dose_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:get/get.dart';

/// App-wide dependencies, created once when the app starts and kept alive
/// for its whole life (`permanent`).
///
/// It holds the single database, its local data sources, the password hasher
/// and the auth repository. `SessionService`, `LanguageService` and
/// `OnboardingStatusService` are not created here: they load saved values
/// asynchronously, so `main.dart` registers them before the first frame.
/// Feature bindings add their own controllers and repositories.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final AppDatabase database = Get.put<AppDatabase>(
      AppDatabase(),
      permanent: true,
    );

    final AccountsLocalDataSource accounts = Get.put<AccountsLocalDataSource>(
      AccountsLocalDataSource(database),
      permanent: true,
    );
    final ProfilesLocalDataSource profiles = Get.put<ProfilesLocalDataSource>(
      ProfilesLocalDataSource(database),
      permanent: true,
    );
    Get.put<MedicationsLocalDataSource>(
      MedicationsLocalDataSource(database),
      permanent: true,
    );
    Get.put<DoseTimesLocalDataSource>(
      DoseTimesLocalDataSource(database),
      permanent: true,
    );
    Get.put<DoseLogsLocalDataSource>(
      DoseLogsLocalDataSource(database),
      permanent: true,
    );
    final PasswordHasher hasher = Get.put<PasswordHasher>(
      const PasswordHasher(),
      permanent: true,
    );

    Get.put<AuthRepository>(
      AuthRepository(
        accounts: accounts,
        hasher: hasher,
        session: Get.find<SessionService>(),
      ),
      permanent: true,
    );

    Get.put<ProfilesRepository>(
      ProfilesRepository(
        profiles: profiles,
        session: Get.find<SessionService>(),
      ),
      permanent: true,
    );
  }
}
