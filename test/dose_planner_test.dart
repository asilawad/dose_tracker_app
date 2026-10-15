import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/medications/data/models/dose_time.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Profile profile = Profile(
    id: 1,
    name: 'Test',
    personaColor: PersonaColor.teal,
    remindersEnabled: true,
  );
  // Added on Oct 15 at 12:00:30, with doses at 08:00, 12:00 and 20:00.
  final Medication medication = Medication(
    id: 1,
    profileId: 1,
    name: 'Vitamin D',
    doseAmount: 500,
    doseUnit: DoseUnit.mg,
    mealInstruction: null,
    trackInventory: false,
    stockTotal: null,
    stockRemaining: null,
    isActive: true,
    createdAt: DateTime(2026, 10, 15, 12, 0, 30),
    doseTimes: const <DoseTime>[
      DoseTime(id: 1, minuteOfDay: 480, quantity: 1),
      DoseTime(id: 2, minuteOfDay: 720, quantity: 1),
      DoseTime(id: 3, minuteOfDay: 1200, quantity: 1),
    ],
  );
  final DateTime now = DateTime(2026, 10, 15, 13);

  List<ScheduledDose> plan(DateTime date) {
    return DosePlanner.build(
      date: date,
      now: now,
      medications: <Medication>[medication],
      profiles: <Profile>[profile],
      logs: const [],
    );
  }

  List<int> minutesOf(List<ScheduledDose> doses) {
    return doses.map((ScheduledDose dose) => dose.minuteOfDay).toList();
  }

  group('DosePlanner creation moment', () {
    test('hides doses earlier than the minute the medication was added', () {
      final List<ScheduledDose> doses = plan(DateTime(2026, 10, 15));
      expect(minutesOf(doses), <int>[720, 1200]);
    });

    test('the remaining doses of the first day are pending, not missed', () {
      final List<ScheduledDose> doses = plan(DateTime(2026, 10, 15));
      expect(
        doses.map((ScheduledDose dose) => dose.state),
        everyElement(DoseState.pending),
      );
    });

    test('shows nothing on days before the medication was added', () {
      expect(plan(DateTime(2026, 10, 14)), isEmpty);
    });

    test('shows every dose from the next day on', () {
      final List<ScheduledDose> doses = plan(DateTime(2026, 10, 16));
      expect(minutesOf(doses), <int>[480, 720, 1200]);
    });
  });
}
