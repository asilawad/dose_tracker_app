import 'package:dose_tracker/features/schedule/data/models/dose_state.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:flutter/foundation.dart';

/// How a day looks on the adherence calendar.
enum DayAdherenceStatus {
  /// No doses were scheduled that day.
  none,

  /// Every dose of the day is still pending.
  upcoming,

  /// Every dose was taken (on time or late).
  allTaken,

  /// Some doses were taken and others were not.
  partial,

  /// No dose was taken, and at least one was missed or skipped.
  missed,
}

/// The dose counts of one day for one profile, with the status the calendar
/// shows for it.
///
/// [taken] counts both taken and taken-late doses. [pending] doses are the
/// ones not yet due, and they are left out of the adherence rate.
@immutable
class AdherenceDay {
  const AdherenceDay({
    required this.date,
    required this.total,
    required this.taken,
    required this.skipped,
    required this.missed,
    required this.pending,
  });

  /// Counts the states of [doses], which must all belong to [date].
  factory AdherenceDay.fromDoses({
    required DateTime date,
    required Iterable<ScheduledDose> doses,
  }) {
    int total = 0;
    int taken = 0;
    int skipped = 0;
    int missed = 0;
    int pending = 0;
    for (final ScheduledDose dose in doses) {
      total++;
      switch (dose.state) {
        case DoseState.taken:
        case DoseState.takenLate:
          taken++;
        case DoseState.skipped:
          skipped++;
        case DoseState.missed:
          missed++;
        case DoseState.pending:
          pending++;
      }
    }
    return AdherenceDay(
      date: date,
      total: total,
      taken: taken,
      skipped: skipped,
      missed: missed,
      pending: pending,
    );
  }

  final DateTime date;
  final int total;
  final int taken;
  final int skipped;
  final int missed;
  final int pending;

  /// The doses already due: taken, skipped or missed.
  int get elapsed => taken + skipped + missed;

  DayAdherenceStatus get status {
    if (total == 0) {
      return DayAdherenceStatus.none;
    }
    if (taken == total) {
      return DayAdherenceStatus.allTaken;
    }
    if (taken > 0) {
      return DayAdherenceStatus.partial;
    }
    if (missed + skipped > 0) {
      return DayAdherenceStatus.missed;
    }
    return DayAdherenceStatus.upcoming;
  }

  /// The share of due doses that were taken over [days], from 0 to 1, or
  /// null when no dose was due yet.
  static double? rate(Iterable<AdherenceDay> days) {
    int taken = 0;
    int elapsed = 0;
    for (final AdherenceDay day in days) {
      taken += day.taken;
      elapsed += day.elapsed;
    }
    return elapsed == 0 ? null : taken / elapsed;
  }
}
