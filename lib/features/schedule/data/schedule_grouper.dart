import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/features/profiles/data/models/profile_avatar.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';

class ScheduleProfileGroup {
  const ScheduleProfileGroup({
    required this.profileId,
    required this.profileName,
    required this.personaColor,
    this.profileAvatar,
    required this.doses,
  });

  final int profileId;
  final String profileName;
  final PersonaColor personaColor;
  final ProfileAvatar? profileAvatar;
  final List<ScheduledDose> doses;
}

class ScheduleTimeGroup {
  const ScheduleTimeGroup({
    required this.minuteOfDay,
    required this.profiles,
  });

  final int minuteOfDay;
  final List<ScheduleProfileGroup> profiles;
}

abstract final class ScheduleGrouper {
  static List<ScheduleTimeGroup> group(List<ScheduledDose> doses) {
    final Set<String> seenKeys = <String>{};
    final Map<int, Map<int, List<ScheduledDose>>> grouped =
        <int, Map<int, List<ScheduledDose>>>{};

    for (final ScheduledDose dose in doses) {
      if (!seenKeys.add(dose.key)) {
        continue;
      }
      grouped
          .putIfAbsent(dose.minuteOfDay, () => <int, List<ScheduledDose>>{})
          .putIfAbsent(dose.profileId, () => <ScheduledDose>[])
          .add(dose);
    }

    final List<int> times = grouped.keys.toList()..sort();
    return times.map((int minuteOfDay) {
      final Map<int, List<ScheduledDose>> profiles = grouped[minuteOfDay]!;
      final List<int> profileIds = profiles.keys.toList()..sort();
      return ScheduleTimeGroup(
        minuteOfDay: minuteOfDay,
        profiles: profileIds.map((int profileId) {
          final List<ScheduledDose> profileDoses = profiles[profileId]!;
          final ScheduledDose firstDose = profileDoses.first;
          return ScheduleProfileGroup(
            profileId: profileId,
            profileName: firstDose.profileName,
            personaColor: firstDose.personaColor,
            profileAvatar: firstDose.profileAvatar,
            doses: profileDoses,
          );
        }).toList(),
      );
    }).toList();
  }
}
