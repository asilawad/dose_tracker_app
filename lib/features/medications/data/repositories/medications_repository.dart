import 'dart:async';

import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/medications_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/profiles_local_data_source.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:dose_tracker/core/utils/dose_scheduler.dart';
import 'package:dose_tracker/features/medications/data/models/dose_time.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/data/models/medication_results.dart';

/// All medication rules in one place. It always works on the logged-in
/// account: the account id comes from the session here, so no screen can
/// ask for another account's medications, and every query it runs is
/// filtered by that id.
///
/// Call it only after login. A medication and its dose times are saved in
/// one transaction, so a failure never leaves a medication without its
/// schedule. Names are saved trimmed.
class MedicationsRepository {
  const MedicationsRepository({
    required AppDatabase database,
    required MedicationsLocalDataSource medications,
    required DoseTimesLocalDataSource doseTimes,
    required ProfilesLocalDataSource profiles,
    required SessionService session,
  }) : _database = database,
       _medications = medications,
       _doseTimes = doseTimes,
       _profiles = profiles,
       _session = session;

  final AppDatabase _database;
  final MedicationsLocalDataSource _medications;
  final DoseTimesLocalDataSource _doseTimes;
  final ProfilesLocalDataSource _profiles;
  final SessionService _session;

  /// Live list of every medication in the account with its dose times,
  /// oldest first. Emits again when a medication or any dose time changes.
  Stream<List<Medication>> watchMedications() {
    final int accountId = _session.requireActiveAccountId();

    late final StreamController<List<Medication>> controller;
    StreamSubscription<List<MedicationRow>>? medicationsSubscription;
    StreamSubscription<List<DoseTimeRow>>? timesSubscription;
    List<MedicationRow>? latestMedications;
    List<DoseTimeRow>? latestTimes;

    void emit() {
      final List<MedicationRow>? medications = latestMedications;
      final List<DoseTimeRow>? times = latestTimes;
      if (medications == null || times == null) {
        return;
      }
      controller.add(_combine(medications, times));
    }

    controller = StreamController<List<Medication>>(
      onListen: () {
        medicationsSubscription = _medications.watchByAccount(accountId).listen(
          (List<MedicationRow> rows) {
            latestMedications = rows;
            emit();
          },
          onError: controller.addError,
        );
        timesSubscription = _doseTimes.watchByAccount(accountId).listen((
          List<DoseTimeRow> rows,
        ) {
          latestTimes = rows;
          emit();
        }, onError: controller.addError);
      },
      onCancel: () async {
        await medicationsSubscription?.cancel();
        await timesSubscription?.cancel();
      },
    );
    return controller.stream;
  }

  /// Saves a medication for [profileId] with its dose [times].
  ///
  /// When [trackInventory] is true, [currentStock] becomes both the total
  /// and the remaining stock; otherwise both stay empty.
  Future<AddMedicationResult> addMedication({
    required int profileId,
    required String name,
    required double doseAmount,
    required DoseUnit doseUnit,
    required MealInstruction? mealInstruction,
    required List<DoseTimeInput> times,
    required bool trackInventory,
    int? currentStock,
  }) async {
    final int accountId = _session.requireActiveAccountId();

    if (!_isValidSchedule(times)) {
      return const AddMedicationInvalidSchedule();
    }
    if (trackInventory && (currentStock == null || currentStock <= 0)) {
      return const AddMedicationInvalidStock();
    }

    final String trimmedName = name.trim();
    final int? stock = trackInventory ? currentStock : null;

    return _database.transaction<AddMedicationResult>(() async {
      final ProfileRow? profile = await _profiles.findById(
        accountId: accountId,
        id: profileId,
      );
      if (profile == null) {
        return const AddMedicationProfileNotFound();
      }

      final int id = await _medications.insert(
        accountId: accountId,
        profileId: profileId,
        name: trimmedName,
        doseAmount: doseAmount,
        doseUnit: doseUnit,
        mealInstruction: mealInstruction,
        trackInventory: trackInventory,
        stockTotal: stock,
        stockRemaining: stock,
      );
      await _doseTimes.replaceForMedication(
        accountId: accountId,
        medicationId: id,
        times: times,
      );
      final List<DoseTimeRow> savedTimes = await _doseTimes.findByMedication(
        accountId: accountId,
        medicationId: id,
      );

      return AddMedicationSuccess(
        Medication(
          id: id,
          profileId: profileId,
          name: trimmedName,
          doseAmount: doseAmount,
          doseUnit: doseUnit,
          mealInstruction: mealInstruction,
          trackInventory: trackInventory,
          stockTotal: stock,
          stockRemaining: stock,
          isActive: true,
          createdAt: DateTime.now(),
          doseTimes: savedTimes.map(_toDoseTime).toList(),
        ),
      );
    });
  }

  /// Records a refill: [newStock] is the count on hand after refilling. It
  /// becomes the remaining stock, and the stock total grows to it when it is
  /// larger than the old total.
  Future<RestockResult> restock({
    required int medicationId,
    required int newStock,
  }) async {
    final int accountId = _session.requireActiveAccountId();

    if (newStock <= 0) {
      return const RestockInvalidAmount();
    }
    final MedicationRow? row = await _medications.findById(
      accountId: accountId,
      id: medicationId,
    );
    if (row == null) {
      return const RestockNotFound();
    }
    if (!row.trackInventory) {
      return const RestockNotTracked();
    }

    final int oldTotal = row.stockTotal ?? 0;
    await _medications.updateStock(
      accountId: accountId,
      id: medicationId,
      stockTotal: newStock > oldTotal ? newStock : oldTotal,
      stockRemaining: newStock,
    );
    return const RestockSuccess();
  }

  /// Pauses ([isActive] false) or resumes a medication. A paused medication
  /// has no doses in the schedule; its history stays.
  Future<SetActiveResult> setActive({
    required int medicationId,
    required bool isActive,
  }) async {
    final int accountId = _session.requireActiveAccountId();

    final MedicationRow? row = await _medications.findById(
      accountId: accountId,
      id: medicationId,
    );
    if (row == null) {
      return const SetActiveNotFound();
    }
    await _medications.setActive(
      accountId: accountId,
      id: medicationId,
      isActive: isActive,
    );
    return const SetActiveSuccess();
  }

  bool _isValidSchedule(List<DoseTimeInput> times) {
    if (times.isEmpty) {
      return false;
    }
    final Set<int> seen = <int>{};
    for (final DoseTimeInput time in times) {
      final bool inRange =
          time.minuteOfDay >= 0 &&
          time.minuteOfDay < DoseScheduler.minutesPerDay;
      if (!inRange || time.quantity <= 0 || !seen.add(time.minuteOfDay)) {
        return false;
      }
    }
    return true;
  }

  List<Medication> _combine(
    List<MedicationRow> medications,
    List<DoseTimeRow> times,
  ) {
    final Map<int, List<DoseTime>> timesByMedication = <int, List<DoseTime>>{};
    for (final DoseTimeRow row in times) {
      timesByMedication
          .putIfAbsent(row.medicationId, () => <DoseTime>[])
          .add(_toDoseTime(row));
    }
    return medications
        .map(
          (MedicationRow row) => Medication(
            id: row.id,
            profileId: row.profileId,
            name: row.name,
            doseAmount: row.doseAmount,
            doseUnit: row.doseUnit,
            mealInstruction: row.mealInstruction,
            trackInventory: row.trackInventory,
            stockTotal: row.stockTotal,
            stockRemaining: row.stockRemaining,
            isActive: row.isActive,
            createdAt: row.createdAt,
            doseTimes: timesByMedication[row.id] ?? const <DoseTime>[],
          ),
        )
        .toList();
  }

  DoseTime _toDoseTime(DoseTimeRow row) {
    return DoseTime(
      id: row.id,
      minuteOfDay: row.minuteOfDay,
      quantity: row.quantity,
    );
  }
}
