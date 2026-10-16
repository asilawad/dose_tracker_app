import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/features/home/data/repositories/profile_summary_builder.dart';
import 'package:dose_tracker/features/medications/data/models/dose_time.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:flutter_test/flutter_test.dart';

Profile _profile(int id) => Profile(
  id: id,
  name: 'P$id',
  personaColor: PersonaColor.teal,
  remindersEnabled: true,
);

Medication _medication(int profileId, {bool isActive = true}) => Medication(
  id: profileId * 10 + (isActive ? 1 : 2),
  profileId: profileId,
  name: 'Med',
  doseAmount: 1,
  doseUnit: DoseUnit.mg,
  mealInstruction: null,
  trackInventory: false,
  stockThreshold: null,
  stockRemaining: null,
  isActive: isActive,
  createdAt: DateTime(2026, 10, 1),
  doseTimes: const <DoseTime>[DoseTime(id: 1, minuteOfDay: 480, quantity: 1)],
);

ScheduledDose _dose(int profileId, DoseState state) => ScheduledDose(
  medicationId: profileId * 10 + 1,
  profileId: profileId,
  profileName: 'P$profileId',
  personaColor: PersonaColor.teal,
  medicationName: 'Med',
  doseAmount: 1,
  doseUnit: DoseUnit.mg,
  mealInstruction: null,
  date: DateTime(2026, 10, 16),
  minuteOfDay: 480,
  quantity: 1,
  state: state,
  logId: null,
  takenAt: null,
  skipReason: null,
);

void main() {
  group('ProfileSummaryBuilder', () {
    test('counts only active medications of each profile', () {
      final List<ProfileSummary> result = ProfileSummaryBuilder.build(
        profiles: <Profile>[_profile(1), _profile(2)],
        medications: <Medication>[
          _medication(1),
          _medication(1, isActive: false),
          _medication(2),
        ],
        doses: const <ScheduledDose>[],
      );
      expect(result.map((ProfileSummary s) => s.medicationCount), <int>[1, 1]);
    });

    test('taken and late doses count as progress, skipped does not', () {
      final List<ProfileSummary> result = ProfileSummaryBuilder.build(
        profiles: <Profile>[_profile(1)],
        medications: <Medication>[_medication(1)],
        doses: <ScheduledDose>[
          _dose(1, DoseState.taken),
          _dose(1, DoseState.takenLate),
          _dose(1, DoseState.skipped),
          _dose(1, DoseState.pending),
        ],
      );
      expect(result.single.takenToday, 2);
      expect(result.single.totalToday, 4);
      expect(result.single.progress, 0.5);
    });

    test('doses of another profile are ignored and no doses gives 0', () {
      final List<ProfileSummary> result = ProfileSummaryBuilder.build(
        profiles: <Profile>[_profile(1)],
        medications: const <Medication>[],
        doses: <ScheduledDose>[_dose(2, DoseState.taken)],
      );
      expect(result.single.totalToday, 0);
      expect(result.single.progress, 0);
    });
  });
}
