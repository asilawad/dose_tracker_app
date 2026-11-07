import 'package:dose_tracker/features/home/controllers/home_controller.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/data/models/medication_results.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'support/test_env.dart';

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

  Future<int> addMedication({
    required String name,
    List<int> minutes = const <int>[480],
    int? stock,
  }) async {
    final AddMedicationResult result = await env.medications.addMedication(
      profileId: profileId,
      name: name,
      doseAmount: 1,
      doseUnit: DoseUnit.pills,
      mealInstruction: null,
      times: <({int minuteOfDay, double quantity})>[
        for (final int minute in minutes) (minuteOfDay: minute, quantity: 1),
      ],
      trackInventory: stock != null,
      currentStock: stock,
    );
    return (result as AddMedicationSuccess).medication.id;
  }

  Future<HomeController> startController() async {
    final HomeController controller = Get.put<HomeController>(
      HomeController(env.profiles, env.medications, env.doseLogs),
    );
    addTearDown(() => Get.delete<HomeController>(force: true));
    await pumpEventQueue();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await pumpEventQueue();
    return controller;
  }

  test('counts active medications at or below their refill level', () async {
    await addMedication(name: 'Low', stock: 3);
    await addMedication(name: 'Full', stock: 30);
    await addMedication(name: 'Untracked');
    final int paused = await addMedication(name: 'Paused low', stock: 2);
    await env.updates.setActive(medicationId: paused, isActive: false);

    final HomeController controller = await startController();

    expect(controller.isLoading.value, isFalse);
    expect(controller.lowStockCount.value, 1);
  });

  test('up next lists pending doses soonest first, at most three', () async {
    final DateTime now = DateTime.now();
    final int nowMinute = now.hour * 60 + now.minute;
    if (nowMinute > 20 * 60) {
      markTestSkipped('Needs four dose times still ahead today.');
      return;
    }
    final int start = nowMinute + 60;
    await addMedication(
      name: 'Later',
      minutes: <int>[start + 120, start + 180],
    );
    await addMedication(name: 'Soon', minutes: <int>[start, start + 60]);

    final HomeController controller = await startController();

    expect(controller.upNext.map((dose) => dose.minuteOfDay).toList(), <int>[
      start,
      start + 60,
      start + 120,
    ]);
    expect(controller.upNext.length, HomeController.upNextLimit);
  });
}
