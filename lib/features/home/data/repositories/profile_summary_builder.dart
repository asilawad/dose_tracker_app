import 'package:dose_tracker/features/home/data/models/profile_summary.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';

/// Builds the Home summaries. Pure logic, no database and no clock.
abstract final class ProfileSummaryBuilder {
  /// One summary per profile, in the order of [profiles]. [doses] are the
  /// doses of a single day (today). Paused medications are not counted.
  static List<ProfileSummary> build({
    required List<Profile> profiles,
    required List<Medication> medications,
    required List<ScheduledDose> doses,
  }) {
    return <ProfileSummary>[
      for (final Profile profile in profiles)
        _summary(profile, medications, doses),
    ];
  }

  static ProfileSummary _summary(
    Profile profile,
    List<Medication> medications,
    List<ScheduledDose> doses,
  ) {
    final List<ScheduledDose> own = doses
        .where((ScheduledDose dose) => dose.profileId == profile.id)
        .toList();
    final int taken = own.where((ScheduledDose dose) {
      return dose.state == DoseState.taken ||
          dose.state == DoseState.takenLate;
    }).length;
    final int count = medications.where((Medication medication) {
      return medication.profileId == profile.id && medication.isActive;
    }).length;
    return ProfileSummary(
      profile: profile,
      medicationCount: count,
      takenToday: taken,
      totalToday: own.length,
    );
  }
}
