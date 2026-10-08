import 'package:dose_tracker/core/constants/storage_keys.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers which local account is logged in, across app restarts.
///
/// Logging out only clears this pointer. It never deletes an account's data,
/// so logging back in restores that account's own profiles and history, and
/// a different account can never see them because every query filters by the
/// account id this service provides.
///
/// Create it once at startup with
/// `await Get.putAsync(SessionService.create, permanent: true)`.
class SessionService extends GetxService {
  SessionService._(this._preferences) {
    _activeAccountId.value = _preferences.getInt(StorageKeys.activeAccountId);
  }

  final SharedPreferences _preferences;
  final Rxn<int> _activeAccountId = Rxn<int>();

  static Future<SessionService> create() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return SessionService._(preferences);
  }

  /// Id of the logged-in account, or null when nobody is logged in.
  int? get activeAccountId => _activeAccountId.value;

  bool get isLoggedIn => activeAccountId != null;

  /// The logged-in account id for code that must only run after login.
  /// Throws if nobody is logged in, which means a screen was reached without
  /// passing the login check, a bug rather than a user error.
  int requireActiveAccountId() {
    final int? id = activeAccountId;
    if (id == null) {
      throw StateError('No account is logged in.');
    }
    return id;
  }

  Future<void> signIn(int accountId) async {
    await _preferences.setInt(StorageKeys.activeAccountId, accountId);
    _activeAccountId.value = accountId;
  }

  Future<void> signOut() async {
    await _preferences.remove(StorageKeys.activeAccountId);
    _activeAccountId.value = null;
  }
}
