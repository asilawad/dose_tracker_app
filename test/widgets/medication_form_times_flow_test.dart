import 'dart:async';

import 'package:dose_tracker/app/routes/app_pages.dart';
import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/theme/app_theme.dart';
import 'package:dose_tracker/core/translations/app_translations.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/medications/controllers/medication_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../support/test_env.dart';

/// Drives the real Add Medication screen (route, binding, sheet) to check
/// that dose times edited by hand survive adding and removing times.
void main() {
  late TestEnv env;
  late int profileId;

  setUp(() async {
    env = await TestEnv.create();
    profileId = await env.addProfile();
  });

  tearDown(() async {
    await env.dispose();
  });

  Future<void> openForm(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light(),
        translations: AppTranslations(),
        locale: AppTranslations.fallbackLocale,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppTranslations.supportedLocales,
        getPages: AppPages.pages,
        home: const SizedBox.shrink(),
      ),
    );
    unawaited(Get.toNamed<void>(AppRoutes.addMedication, arguments: profileId));
    await tester.pumpAndSettle();
  }

  List<int> minutes() => Get.find<MedicationFormController>().form.times
      .map((DoseTimeInput time) => time.minuteOfDay)
      .toList();

  testWidgets('a time edited in the sheet survives adding and removing', (
    WidgetTester tester,
  ) async {
    await openForm(tester);
    final Finder addTime = find.text('Add another time');

    await tester.ensureVisible(addTime);
    await tester.tap(addTime);
    await tester.pumpAndSettle();
    await tester.tap(addTime);
    await tester.pumpAndSettle();
    expect(minutes(), <int>[480, 840, 1200]);

    // Open the 2 PM row's sheet and change only the amount.
    await tester.tap(find.text(DoseFormatter.minuteOfDay(840)));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, '2');
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    final MedicationFormController controller =
        Get.find<MedicationFormController>();
    expect(controller.form.times[1].quantity, 2);

    await tester.ensureVisible(addTime);
    await tester.tap(addTime);
    await tester.pumpAndSettle();
    expect(controller.form.times.length, 4);
    expect(
      controller.form.times.any(
        (DoseTimeInput time) => time.minuteOfDay == 840 && time.quantity == 2,
      ),
      isTrue,
      reason: 'times after adding: ${controller.form.times}',
    );

    // Unmount the screen and let its closing timers (route transition,
    // database stream cleanup) run, so none is left pending.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
  });
}
