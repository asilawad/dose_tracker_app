import 'package:dose_tracker/core/constants/storage_keys.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers whether onboarding was finished or skipped on this device, so
/// it is shown only once. It is a device-level setting, not account data:
/// logging out or switching accounts does not bring onboarding back.
///
/// Create it once at startup with
/// `await Get.putAsync(OnboardingStatusService.create, permanent: true)`.
class OnboardingStatusService extends GetxService {
  OnboardingStatusService._(this._preferences);

  final SharedPreferences _preferences;

  static Future<OnboardingStatusService> create() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return OnboardingStatusService._(preferences);
  }

  bool get isCompleted =>
      _preferences.getBool(StorageKeys.onboardingCompleted) ?? false;

  Future<void> markCompleted() {
    return _preferences.setBool(StorageKeys.onboardingCompleted, true);
  }
}
