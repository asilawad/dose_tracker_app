import 'dart:async';

import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/dose_logs_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/medications_local_data_source.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_log_results.dart';
import 'package:dose_tracker/features/schedule/data/models/dose_status.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:dose_tracker/features/schedule/data/repositories/dose_planner.dart';

/// All dose recording rules in one place. It always works on the logged-in
/// account: the account id comes from the session here, and every query it
/// runs is filtered by that id.
///
/// Call it only after login. Taking a dose also lowers the medication's
/// stock (when stock tracking is on) by the dose quantity rounded up, never
/// below zero, in the same transaction as the log; changing or undoing a
/// taken dose gives that amount back, never above the stock total. Doses of
/// a day after today cannot be recorded.
class DoseLogsRepository {
  const DoseLogsRepository({
    required AppDatabase database,
    required DoseLogsLocalDataSource doseLogs,
    required MedicationsLocalDataSource medications,
    required DoseTimesLocalDataSource doseTimes,
    required MedicationsRepository medicationsRepository,
    required ProfilesRepository profilesRepository,
    required SessionService session,
  }) : _database = database,
       _doseLogs = doseLogs,
       _medications = medications,
       _doseTimes = doseTimes,
       _medicationsRepository = medicationsRepository,
       _profilesRepository = profilesRepository,
       _session = session;

  final AppDatabase _database;
  final DoseLogsLocalDataSource _doseLogs;
  final MedicationsLocalDataSource _medications;
  final DoseTimesLocalDataSource _doseTimes;
  final MedicationsRepository _medicationsRepository;
  final ProfilesRepository _profilesRepository;
  final SessionService _session;

  /// Live list of the doses of [date], earliest first. It emits again when a
  /// medication, a profile or a log changes, and every
  /// [AppDurations.scheduleRefresh] so a pending dose turns missed on time.
  Stream<List<ScheduledDose>> watchDay(DateTime date) {
    final int accountId = _session.requireActiveAccountId();
    final DateTime day = DosePlanner.dayStart(date);

    late final StreamController<List<ScheduledDose>> controller;
    final List<StreamSubscription<Object?>> subscriptions =
        <StreamSubscription<Object?>>[];
    List<Medication>? medications;
    List<Profile>? profiles;
    List<DoseLogRow>? logs;

    void emit() {
      final List<Medication>? currentMedications = medications;
      final List<Profile>? currentProfiles = profiles;
      final List<DoseLogRow>? currentLogs = logs;
      if (currentMedications == null ||
          currentProfiles == null ||
          currentLogs == null) {
        return;
      }
      controller.add(
        DosePlanner.build(
          date: day,
          now: DateTime.now(),
          medications: currentMedications,
          profiles: currentProfiles,
          logs: currentLogs,
        ),
      );
    }

    controller = StreamController<List<ScheduledDose>>(
      onListen: () {
        subscriptions.addAll(<StreamSubscription<Object?>>[
          _medicationsRepository.watchMedications().listen((
            List<Medication> value,
          ) {
            medications = value;
            emit();
          }, onError: controller.addError),
          _profilesRepository.watchProfiles().listen((List<Profile> value) {
            profiles = value;
            emit();
          }, onError: controller.addError),
          _doseLogs
              .watchByDateRange(accountId: accountId, from: day, to: day)
              .listen((List<DoseLogRow> value) {
                logs = value;
                emit();
              }, onError: controller.addError),
          Stream<void>.periodic(AppDurations.scheduleRefresh).listen((_) {
            emit();
          }),
        ]);
      },
      onCancel: () async {
        for (final StreamSubscription<Object?> subscription in subscriptions) {
          await subscription.cancel();
        }
      },
    );
    return controller.stream;
  }

  /// Marks a dose as taken now: taken, or taken late when it is more than
  /// the grace period after its time.
  Future<LogDoseResult> takeDose({
    required int medicationId,
    required DateTime date,
    required int minuteOfDay,
  }) {
    return _record(
      medicationId: medicationId,
      date: date,
      minuteOfDay: minuteOfDay,
      explicitStatus: null,
      skipReason: null,
    );
  }

  /// Marks a dose as skipped on purpose, with an optional free-text reason.
  Future<LogDoseResult> skipDose({
    required int medicationId,
    required DateTime date,
    required int minuteOfDay,
    String? reason,
  }) {
    final String? trimmed = reason?.trim();
    return _record(
      medicationId: medicationId,
      date: date,
      minuteOfDay: minuteOfDay,
      explicitStatus: DoseStatus.skipped,
      skipReason: trimmed == null || trimmed.isEmpty ? null : trimmed,
    );
  }

  /// Removes a dose's log, which puts the dose back to pending.
  Future<UndoDoseResult> undoDose(int logId) async {
    final int accountId = _session.requireActiveAccountId();

    return _database.transaction<UndoDoseResult>(() async {
      final DoseLogRow? log = await _doseLogs.findById(
        accountId: accountId,
        id: logId,
      );
      if (log == null) {
        return const UndoDoseNotFound();
      }
      if (_wasTaken(log.status)) {
        await _changeStock(
          accountId: accountId,
          medicationId: log.medicationId,
          delta: _stockUnits(log.quantity),
        );
      }
      await _doseLogs.deleteById(accountId: accountId, id: logId);
      return const UndoDoseSuccess();
    });
  }

  Future<LogDoseResult> _record({
    required int medicationId,
    required DateTime date,
    required int minuteOfDay,
    required DoseStatus? explicitStatus,
    required String? skipReason,
  }) async {
    final int accountId = _session.requireActiveAccountId();
    final DateTime day = DosePlanner.dayStart(date);
    final DateTime now = DateTime.now();
    if (day.isAfter(DosePlanner.dayStart(now))) {
      return const LogDoseFutureDay();
    }

    return _database.transaction<LogDoseResult>(() async {
      final MedicationRow? medication = await _medications.findById(
        accountId: accountId,
        id: medicationId,
      );
      if (medication == null) {
        return const LogDoseNotFound();
      }
      final List<DoseTimeRow> times = await _doseTimes.findByMedication(
        accountId: accountId,
        medicationId: medicationId,
      );
      DoseTimeRow? time;
      for (final DoseTimeRow candidate in times) {
        if (candidate.minuteOfDay == minuteOfDay) {
          time = candidate;
        }
      }
      if (time == null) {
        return const LogDoseNotFound();
      }

      final DoseLogRow? previous = await _doseLogs.findForDose(
        accountId: accountId,
        medicationId: medicationId,
        scheduledDate: day,
        scheduledMinuteOfDay: minuteOfDay,
      );
      final DoseStatus status =
          explicitStatus ??
          DosePlanner.takenStatus(
            date: day,
            minuteOfDay: minuteOfDay,
            takenAt: now,
          );
      final bool isTaking = _wasTaken(status);

      await _doseLogs.upsert(
        accountId: accountId,
        profileId: medication.profileId,
        medicationId: medicationId,
        doseTimeId: time.id,
        scheduledDate: day,
        scheduledMinuteOfDay: minuteOfDay,
        quantity: time.quantity,
        status: status,
        takenAt: isTaking ? now : null,
        skipReason: skipReason,
      );

      int delta = 0;
      if (previous != null && _wasTaken(previous.status)) {
        delta += _stockUnits(previous.quantity);
      }
      if (isTaking) {
        delta -= _stockUnits(time.quantity);
      }
      await _changeStock(
        accountId: accountId,
        medicationId: medicationId,
        delta: delta,
      );
      return const LogDoseSuccess();
    });
  }

  /// Adds [delta] (negative to decrease) to the remaining stock when the
  /// medication tracks stock, keeping it between zero and the stock total.
  Future<void> _changeStock({
    required int accountId,
    required int medicationId,
    required int delta,
  }) async {
    if (delta == 0) {
      return;
    }
    final MedicationRow? medication = await _medications.findById(
      accountId: accountId,
      id: medicationId,
    );
    final int? remaining = medication?.stockRemaining;
    if (medication == null || !medication.trackInventory || remaining == null) {
      return;
    }
    final int cap = medication.stockTotal ?? remaining;
    final int updated = (remaining + delta).clamp(0, cap).toInt();
    await _medications.updateStock(
      accountId: accountId,
      id: medicationId,
      stockTotal: medication.stockTotal,
      stockRemaining: updated,
    );
  }

  bool _wasTaken(DoseStatus status) {
    return status == DoseStatus.taken || status == DoseStatus.takenLate;
  }

  int _stockUnits(double quantity) => quantity.ceil();
}
