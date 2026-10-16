import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:flutter/foundation.dart';

/// What the Home card of one family member shows: the number of active
/// medications and today's progress.
@immutable
class ProfileSummary {
  const ProfileSummary({
    required this.profile,
    required this.medicationCount,
    required this.takenToday,
    required this.totalToday,
  });

  final Profile profile;
  final int medicationCount;

  /// Today's doses taken, on time or late.
  final int takenToday;

  /// All of today's doses of this profile, whatever their state.
  final int totalToday;

  /// Fraction from 0 to 1; 0 when there are no doses today.
  double get progress => totalToday == 0 ? 0 : takenToday / totalToday;
}
