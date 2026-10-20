import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/schedule/controllers/dose_actions.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:flutter_test/flutter_test.dart';

ScheduledDose dose({
  required int minuteOfDay,
  required DoseState state,
  bool isDue = false,
}) {
  return ScheduledDose(
    medicationId: 1,
    profileId: 1,
    profileName: 'Test',
    personaColor: PersonaColor.teal,
    medicationName: 'Vitamin D',
    doseAmount: 500,
    doseUnit: DoseUnit.mg,
    mealInstruction: null,
    date: DateTime(2026, 10, 15),
    minuteOfDay: minuteOfDay,
    quantity: 1,
    state: state,
    isDue: isDue,
    logId: null,
    takenAt: null,
    skipReason: null,
  );
}

void main() {
  group('DoseActions.filterVisible', () {
    test('keeps pending doses whether due or upcoming', () {
      final ScheduledDose dueDose = dose(
        minuteOfDay: 480,
        state: DoseState.pending,
        isDue: true,
      );
      final ScheduledDose upcomingDose = dose(
        minuteOfDay: 720,
        state: DoseState.pending,
      );

      expect(
        DoseActions.filterVisible(<ScheduledDose>[
          dueDose,
          upcomingDose,
        ], <String>{}),
        <ScheduledDose>[dueDose, upcomingDose],
      );
    });

    test('drops missed, taken, takenLate and skipped doses', () {
      final List<ScheduledDose> doses = <ScheduledDose>[
        dose(minuteOfDay: 480, state: DoseState.missed),
        dose(minuteOfDay: 600, state: DoseState.taken),
        dose(minuteOfDay: 720, state: DoseState.takenLate),
        dose(minuteOfDay: 840, state: DoseState.skipped),
      ];

      expect(DoseActions.filterVisible(doses, <String>{}), isEmpty);
    });

    test('keeps a just-checked taken dose and preserves input order', () {
      final ScheduledDose first = dose(
        minuteOfDay: 480,
        state: DoseState.taken,
      );
      final ScheduledDose second = dose(
        minuteOfDay: 720,
        state: DoseState.pending,
      );
      final ScheduledDose third = dose(
        minuteOfDay: 840,
        state: DoseState.pending,
        isDue: true,
      );

      expect(
        DoseActions.filterVisible(
          <ScheduledDose>[first, second, third],
          <String>{first.key},
        ),
        <ScheduledDose>[first, second, third],
      );
    });
  });

  group('ScheduledDose.canRecord', () {
    test('requires pending state and an open window', () {
      expect(
        dose(minuteOfDay: 480, state: DoseState.pending, isDue: true)
            .canRecord,
        isTrue,
      );
      expect(
        dose(minuteOfDay: 600, state: DoseState.pending).canRecord,
        isFalse,
      );
      expect(
        dose(minuteOfDay: 720, state: DoseState.missed, isDue: true)
            .canRecord,
        isFalse,
      );
      expect(
        dose(minuteOfDay: 840, state: DoseState.taken, isDue: true).canRecord,
        isFalse,
      );
    });
  });
}
