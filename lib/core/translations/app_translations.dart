import 'dart:ui';

import 'package:dose_tracker/core/translations/ar_translations.dart';
import 'package:dose_tracker/core/translations/en_translations.dart';
import 'package:get/get.dart';

/// Registers every language with GetX and defines the supported locales.
///
/// To add a language later: create `xx_translations.dart`, add its [Locale]
/// to [supportedLocales], and map it in [keys]. Nothing else changes.
class AppTranslations extends Translations {
  static const Locale english = Locale('en');
  static const Locale arabic = Locale('ar');

  /// Used when the device language is not supported.
  static const Locale fallbackLocale = english;

  static const List<Locale> supportedLocales = <Locale>[english, arabic];

  @override
  Map<String, Map<String, String>> get keys => <String, Map<String, String>>{
    english.languageCode: EnTranslations.values,
    arabic.languageCode: ArTranslations.values,
  };
}
