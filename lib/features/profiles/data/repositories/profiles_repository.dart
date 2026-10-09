import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/profiles_local_data_source.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/models/profile_results.dart';

/// All profile rules in one place. It always works on the logged-in
/// account: the account id comes from the session here, so no screen can
/// ask for another account's profiles, and every query it runs is filtered
/// by that id.
///
/// Call it only after login. Names are saved trimmed.
class ProfilesRepository {
  const ProfilesRepository({
    required ProfilesLocalDataSource profiles,
    required SessionService session,
  }) : _profiles = profiles,
       _session = session;

  final ProfilesLocalDataSource _profiles;
  final SessionService _session;

  /// Live list of the account's profiles, oldest first.
  Stream<List<Profile>> watchProfiles() {
    final int accountId = _session.requireActiveAccountId();
    return _profiles
        .watchByAccount(accountId)
        .map((List<ProfileRow> rows) => rows.map(_toProfile).toList());
  }

  Future<AddProfileResult> addProfile({
    required String name,
    required PersonaColor personaColor,
    bool remindersEnabled = true,
  }) async {
    final int accountId = _session.requireActiveAccountId();
    final String trimmedName = name.trim();
    final int id = await _profiles.insert(
      accountId: accountId,
      name: trimmedName,
      personaColor: personaColor,
      remindersEnabled: remindersEnabled,
    );
    return AddProfileSuccess(
      Profile(
        id: id,
        name: trimmedName,
        personaColor: personaColor,
        remindersEnabled: remindersEnabled,
      ),
    );
  }

  Profile _toProfile(ProfileRow row) {
    return Profile(
      id: row.id,
      name: row.name,
      personaColor: row.personaColor,
      remindersEnabled: row.remindersEnabled,
    );
  }
}
