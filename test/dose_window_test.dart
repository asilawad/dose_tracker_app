import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/medications/data/models/dose_time.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_window.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Profile profile = Profile(
    id: 1,
    name: 'Test',
    personaColor: PersonaColor.teal,
    remindersEnabled: true,
  );
  final Medication medication = Medication(
    id: 1,
    profileId: 1,
    name: 'Vitamin D',
    doseAmount: 500,
    doseUnit: DoseUnit.mg,
    mealInstruction: null,
    trackInventory: false,
    stockThreshold: null,
    stockRemaining: null,
    isActive: true,
    createdAt: DateTime(2026, 10, 1),
    doseTimes: const <DoseTime>[
      DoseTime(id: 1, minuteOfDay: 480, quantity: 1),
      DoseTime(id: 2, minuteOfDay: 720, quantity: 1),
      DoseTime(id: 3, minuteOfDay: 1200, quantity: 1),
    ],
  );
  final DateTime day = DateTime(2026, 10, 15);

  List<ScheduledDose> planAt(DateTime now, {DateTime? date}) {
    return DosePlanner.build(
      date: date ?? day,
      now: now,
      medications: <Medication>[medication],
      profiles: const <Profile>[profile],
      logs: const [],
    );
  }

  List<DoseState> states(List<ScheduledDose> doses) =>
      doses.map((ScheduledDose dose) => dose.state).toList();
  List<bool> due(List<ScheduledDose> doses) =>
      doses.map((ScheduledDose dose) => dose.isDue).toList();

  group('DosePlanner.deadlineMinute', () {
    test('is the next time of the same medication', () {
      const List<int> times = <int>[1200, 480, 840];
      expect(DosePlanner.deadlineMinute(480, times), 840);
      expect(DosePlanner.deadlineMinute(840, times), 1200);
    });

    test('is midnight for the last dose of the day', () {
      expect(DosePlanner.deadlineMinute(1200, const <int>[480, 1200]), 1440);
    });
  });

  group('DosePlanner.windowAt', () {
    DoseWindow at(DateTime now) => DosePlanner.windowAt(
      date: day,
      minuteOfDay: 480,
      deadlineMinute: 840,
      now: now,
    );

    test('is not open before the dose time', () {
      expect(at(DateTime(2026, 10, 15, 7, 59)), DoseWindow.notYetOpen);
    });

    test('opens exactly at the dose time', () {
      expect(at(DateTime(2026, 10, 15, 8)), DoseWindow.open);
    });

    test('stays open until the next dose time', () {
      expect(at(DateTime(2026, 10, 15, 13, 59)), DoseWindow.open);
    });

    test('closes exactly when the next dose time arrives', () {
      expect(at(DateTime(2026, 10, 15, 14)), DoseWindow.closed);
    });

    test('the last dose of the day stays open until midnight', () {
      DoseWindow last(DateTime now) => DosePlanner.windowAt(
        date: day,
        minuteOfDay: 1200,
        deadlineMinute: 1440,
        now: now,
      );
      expect(last(DateTime(2026, 10, 15, 23, 59)), DoseWindow.open);
      expect(last(DateTime(2026, 10, 16)), DoseWindow.closed);
    });
  });

  group('DosePlanner.build window flags', () {
    test('before the first dose nothing is due', () {
      final List<ScheduledDose> doses = planAt(DateTime(2026, 10, 15, 7));
      expect(states(doses), everyElement(DoseState.pending));
      expect(due(doses), <bool>[false, false, false]);
    });

    test('at 08:00 only the first dose is due', () {
      expect(due(planAt(DateTime(2026, 10, 15, 8))), <bool>[true, false, false]);
    });

    test('at 13:00 the 08:00 dose is missed and locked, 12:00 is due', () {
      final List<ScheduledDose> doses = planAt(DateTime(2026, 10, 15, 13));
      expect(states(doses), <DoseState>[
        DoseState.missed,
        DoseState.pending,
        DoseState.pending,
      ]);
      expect(due(doses), <bool>[false, true, false]);
      expect(doses.map((ScheduledDose d) => d.canRecord), <bool>[
        false,
        true,
        false,
      ]);
    });

    test('at exactly 12:00 the previous dose closes', () {
      final List<ScheduledDose> doses = planAt(DateTime(2026, 10, 15, 12));
      expect(doses.first.state, DoseState.missed);
      expect(due(doses), <bool>[false, true, false]);
    });

    test('at 23:59 only the last dose can still be recorded', () {
      final List<ScheduledDose> doses = planAt(DateTime(2026, 10, 15, 23, 59));
      expect(due(doses), <bool>[false, false, true]);
    });

    test('a future day has nothing due, a past day has nothing due', () {
      final DateTime now = DateTime(2026, 10, 15, 13);
      final List<ScheduledDose> future = planAt(
        now,
        date: DateTime(2026, 10, 16),
      );
      expect(due(future), everyElement(false));
      expect(states(future), everyElement(DoseState.pending));
      final List<ScheduledDose> past = planAt(
        now,
        date: DateTime(2026, 10, 14),
      );
      expect(due(past), everyElement(false));
      expect(states(past), everyElement(DoseState.missed));
    });
  });
}
