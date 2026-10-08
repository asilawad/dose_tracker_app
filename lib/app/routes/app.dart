import 'package:dose_tracker/app/routes/app_pages.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_theme.dart';
import 'package:dose_tracker/core/translations/app_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

/// Root widget: wires the theme, translations (EN/AR with automatic RTL
/// for Arabic) and the route table into GetX.
///
/// Light mode only for now. Dark mode later = pass `darkTheme` here; no
/// screen changes. The saved language is applied in a later step; until then
/// the device language is used, falling back to English.
class DoseTrackerApp extends StatelessWidget {
  const DoseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => AppStrings.appName.tr,
      theme: AppTheme.light(),
      themeMode: ThemeMode.light,
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: AppTranslations.fallbackLocale,
      supportedLocales: AppTranslations.supportedLocales,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
    );
  }
}
