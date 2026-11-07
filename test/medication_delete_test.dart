import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/data/models/medication_results.dart';
import 'package:flutter_test/flutter_test.dart';

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

  Future<Medication> addMedication(String name) async {
    final AddMedicationResult result = await env.medications.addMedication(
      profileId: profileId,
      name: name,
      doseAmount: 500,
      doseUnit: DoseUnit.mg,
      mealInstruction: null,
      times: const <({int minuteOfDay, double quantity})>[
        (minuteOfDay: 480, quantity: 1),
      ],
      trackInventory: false,
    );
    return (result as AddMedicationSuccess).medication;
  }

  test('deleting a medication removes only that medication', () async {
    final Medication panadol = await addMedication('Panadol');
    final Medication omega = await addMedication('Omega 3');

    expect(await env.updates.deleteMedication(panadol.id), isTrue);

    expect(await env.medications.findMedication(panadol.id), isNull);
    expect(await env.medications.findMedication(omega.id), isNotNull);
  });

  test('deleting a medication that is already gone returns false', () async {
    final Medication panadol = await addMedication('Panadol');
    await env.updates.deleteMedication(panadol.id);

    expect(await env.updates.deleteMedication(panadol.id), isFalse);
  });
}
