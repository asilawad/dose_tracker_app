import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/accounts_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/dose_logs_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/medications_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/profiles_local_data_source.dart';
import 'package:dose_tracker/core/services/password_hasher.dart';
import 'package:get/get.dart';

/// App-wide dependencies, created once when the app starts and kept alive
/// for its whole life (`permanent`).
///
/// It holds the single database, its local data sources and the password
/// hasher. `SessionService` and `LanguageService` are not here: they load
/// saved values asynchronously, so `main.dart` creates them before the first
/// frame. Feature bindings add their own controllers and repositories later.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final AppDatabase database = Get.put<AppDatabase>(
      AppDatabase(),
      permanent: true,
    );

    Get.put<AccountsLocalDataSource>(
      AccountsLocalDataSource(database),
      permanent: true,
    );
    Get.put<ProfilesLocalDataSource>(
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
    Get.put<PasswordHasher>(const PasswordHasher(), permanent: true);
  }
}
