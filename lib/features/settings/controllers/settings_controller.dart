import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/services/language_service.dart';
import 'package:dose_tracker/core/translations/app_translations.dart';
import 'package:dose_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Actions of the Settings tab: switching the language and logging out.
///
/// Logging out only clears the session pointer (the repository does that),
/// so the account's data stays on the device and comes back at the next
/// login. The whole navigation stack is then replaced with Log In.
class SettingsController extends GetxController {
  SettingsController(this._language, this._auth);

  final LanguageService _language;
  final AuthRepository _auth;

  /// The language in use, for rows that show it with `Obx`.
  Rx<Locale> get currentLocale => _language.current;

  /// Name of [locale] written in its own language, so a user can always
  /// find theirs in the list.
  String languageName(Locale locale) {
    return locale.languageCode == AppTranslations.arabic.languageCode
        ? AppStrings.languageArabicName.tr
        : AppStrings.languageEnglishName.tr;
  }

  Future<void> changeLanguage(Locale locale) {
    return _language.changeLanguage(locale);
  }

  Future<void> logOut() async {
    await _auth.signOut();
    await Get.offAllNamed<void>(AppRoutes.logIn);
  }
}
