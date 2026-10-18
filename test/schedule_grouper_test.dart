import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/schedule_grouper.dart';
import 'package:flutter_test/flutter_test.dart';

ScheduledDose _dose({
  required int medicationId,
  required int profileId,
  required int minuteOfDay,
  String? profileName,
  DoseState state = DoseState.pending,
}) =>
    ScheduledDose(
      medicationId: medicationId,
      profileId: profileId,
      profileName: profileName ?? 'Profile $profileId',
      personaColor: PersonaColor.teal,
      medicationName: 'Medication',
      doseAmount: 1,
      doseUnit: DoseUnit.mg,
      mealInstruction: null,
      date: DateTime(2026, 10, 18),
      minuteOfDay: minuteOfDay,
      quantity: 1,
      state: state,
      logId: null,
      takenAt: null,
      skipReason: null,
    );

void main() {
  group('ScheduleGrouper', () {
    test('groups matching medication names by profile at one time', () {
      final List<ScheduleTimeGroup> groups = ScheduleGrouper.group(
        <ScheduledDose>[
          _dose(medicationId: 10, profileId: 2, minuteOfDay: 480),
          _dose(medicationId: 20, profileId: 1, minuteOfDay: 480),
        ],
      );

      expect(groups, hasLength(1));
      expect(groups.single.profiles, hasLength(2));
    });

    test('sorts time groups ascending', () {
      final List<ScheduleTimeGroup> groups = ScheduleGrouper.group(
        <ScheduledDose>[
          _dose(medicationId: 1, profileId: 1, minuteOfDay: 720),
          _dose(medicationId: 2, profileId: 1, minuteOfDay: 360),
        ],
      );

      expect(groups.map((ScheduleTimeGroup group) => group.minuteOfDay), <int>[
        360,
        720,
      ]);
    });

    test('sorts profiles inside a time by profile id', () {
      final List<ScheduleTimeGroup> groups = ScheduleGrouper.group(
        <ScheduledDose>[
          _dose(medicationId: 1, profileId: 5, minuteOfDay: 480),
          _dose(medicationId: 2, profileId: 2, minuteOfDay: 480),
        ],
      );

      expect(
        groups.single.profiles.map((ScheduleProfileGroup group) => group.profileId),
        <int>[2, 5],
      );
    });

    test('removes duplicate keys and keeps the first dose', () {
      final ScheduledDose first = _dose(
        medicationId: 1,
        profileId: 1,
        minuteOfDay: 480,
        profileName: 'First',
      );
      final ScheduledDose duplicate = _dose(
        medicationId: 1,
        profileId: 2,
        minuteOfDay: 480,
        profileName: 'Second',
        state: DoseState.missed,
      );

      final List<ScheduleTimeGroup> groups = ScheduleGrouper.group(
        <ScheduledDose>[first, duplicate],
      );

      expect(groups.single.profiles, hasLength(1));
      expect(groups.single.profiles.single.doses, <ScheduledDose>[first]);
      expect(groups.single.profiles.single.profileName, 'First');
    });

    test('returns no groups for empty input', () {
      expect(ScheduleGrouper.group(<ScheduledDose>[]), isEmpty);
    });
  });
}
