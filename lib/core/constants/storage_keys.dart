/// Keys for values saved with `shared_preferences`. No service writes a key
/// by hand: it uses these constants.
///
/// Only small device-level settings live there. All account data (profiles,
/// medications, history) is in the database, never in these keys.
abstract final class StorageKeys {
  /// Id of the account that is logged in. Absent means nobody is logged in.
  /// Logging out only removes this key; it never deletes any account data.
  static const String activeAccountId = 'active_account_id';

  /// Saved app language code (for example `en` or `ar`).
  static const String languageCode = 'language_code';

  /// True after the user has finished or skipped onboarding, so it is shown
  /// only once per device.
  static const String onboardingCompleted = 'onboarding_completed';
}
