import 'dart:ui';

import 'package:dose_tracker/core/constants/storage_keys.dart';
import 'package:dose_tracker/core/translations/app_translations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Remembers the chosen app language and applies changes at runtime.
///
/// On first launch it uses the device language when it is supported
/// (English or Arabic), otherwise English. Switching to Arabic mirrors the
/// whole app to right-to-left automatically, because the Material
/// localization delegates provide the text direction.
///
/// Create it once at startup with
/// `await Get.putAsync(LanguageService.create, permanent: true)`.
class LanguageService extends GetxService {
  LanguageService._(this._preferences) {
    current.value = _initialLocale();
  }

  final SharedPreferences _preferences;

  /// The language in use. Screens can react to it with `Obx`.
  final Rx<Locale> current = AppTranslations.fallbackLocale.obs;

  static Future<LanguageService> create() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return LanguageService._(preferences);
  }

  /// Saves the choice, then switches the live app language.
  Future<void> changeLanguage(Locale locale) async {
    await _preferences.setString(StorageKeys.languageCode, locale.languageCode);
    current.value = locale;
    await Get.updateLocale(locale);
  }

  Locale _initialLocale() {
    final String? savedCode = _preferences.getString(StorageKeys.languageCode);
    return _supportedFor(savedCode) ??
        _supportedFor(PlatformDispatcher.instance.locale.languageCode) ??
        AppTranslations.fallbackLocale;
  }

  Locale? _supportedFor(String? languageCode) {
    for (final Locale locale in AppTranslations.supportedLocales) {
      if (locale.languageCode == languageCode) {
        return locale;
      }
    }
    return null;
  }
}
