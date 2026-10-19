import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/profiles_local_data_source.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/models/profile_avatar.dart';
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
    ProfileAvatar? avatar,
    bool remindersEnabled = true,
  }) async {
    final int accountId = _session.requireActiveAccountId();
    final String trimmedName = name.trim();
    final int id = await _profiles.insert(
      accountId: accountId,
      name: trimmedName,
      personaColor: personaColor,
      avatar: avatar,
      remindersEnabled: remindersEnabled,
    );
    return AddProfileSuccess(
      Profile(
        id: id,
        name: trimmedName,
        personaColor: personaColor,
        remindersEnabled: remindersEnabled,
        avatar: avatar,
      ),
    );
  }

  /// The profile with [id], or null when it is not in this account.
  Future<Profile?> findProfile(int id) async {
    final int accountId = _session.requireActiveAccountId();
    final ProfileRow? row = await _profiles.findById(
      accountId: accountId,
      id: id,
    );
    return row == null ? null : _toProfile(row);
  }

  /// Changes a profile's name and identity color. Its reminder choice stays
  /// as it was.
  Future<UpdateProfileResult> updateProfile({
    required int id,
    required String name,
    required PersonaColor personaColor,
    required ProfileAvatar? avatar,
  }) async {
    final int accountId = _session.requireActiveAccountId();
    final ProfileRow? row = await _profiles.findById(
      accountId: accountId,
      id: id,
    );
    if (row == null) {
      return const UpdateProfileNotFound();
    }

    final String trimmedName = name.trim();
    await _profiles.updateDetails(
      accountId: accountId,
      id: id,
      name: trimmedName,
      personaColor: personaColor,
      avatar: avatar,
      remindersEnabled: row.remindersEnabled,
    );
    return UpdateProfileSuccess(
      Profile(
        id: id,
        name: trimmedName,
        personaColor: personaColor,
        remindersEnabled: row.remindersEnabled,
        avatar: avatar,
      ),
    );
  }

  /// Deletes a profile together with its medications, dose times and history.
  Future<DeleteProfileResult> deleteProfile(int id) async {
    final int accountId = _session.requireActiveAccountId();
    final int deleted = await _profiles.deleteById(
      accountId: accountId,
      id: id,
    );
    return deleted == 0
        ? const DeleteProfileNotFound()
        : const DeleteProfileSuccess();
  }

  Profile _toProfile(ProfileRow row) {
    return Profile(
      id: row.id,
      name: row.name,
      personaColor: row.personaColor,
      remindersEnabled: row.remindersEnabled,
      avatar: row.avatar,
    );
  }
}
