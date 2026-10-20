import 'dart:async';

import 'package:dose_tracker/core/database/app_database.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/medications_local_data_source.dart';
import 'package:dose_tracker/core/database/data_sources/profiles_local_data_source.dart';
import 'package:dose_tracker/core/services/session_service.dart';
import 'package:dose_tracker/core/utils/stock_policy.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/data/models/medication_results.dart';
import 'package:dose_tracker/features/medications/data/repositories/medication_mapper.dart';

/// Reading and creating medications. It always works on the logged-in
/// account: the account id comes from the session here, so no screen can
/// ask for another account's medications, and every query it runs is
/// filtered by that id. Changes to an existing medication live in
/// `MedicationUpdatesRepository`.
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

  Future<Medication?> findMedication(int medicationId) async {
    final int accountId = _session.requireActiveAccountId();
    final MedicationRow? row = await _medications.findById(
      accountId: accountId,
      id: medicationId,
    );
    if (row == null) {
      return null;
    }
    final List<DoseTimeRow> times = await _doseTimes.findByMedication(
      accountId: accountId,
      medicationId: medicationId,
    );
    return MedicationMapper.combine(<MedicationRow>[row], times).first;
  }

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
      controller.add(MedicationMapper.combine(medications, times));
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
  /// When [trackInventory] is true, [currentStock] becomes the remaining
  /// stock and [stockThreshold] the refill alert level; otherwise both stay
  /// empty.
  Future<AddMedicationResult> addMedication({
    required int profileId,
    required String name,
    required double doseAmount,
    required DoseUnit doseUnit,
    required MealInstruction? mealInstruction,
    required List<DoseTimeInput> times,
    required bool trackInventory,
    int? currentStock,
    int stockThreshold = StockPolicy.defaultThreshold,
  }) async {
    final int accountId = _session.requireActiveAccountId();

    if (!MedicationMapper.isValidSchedule(times)) {
      return const AddMedicationInvalidSchedule();
    }
    if (trackInventory &&
        (currentStock == null || currentStock <= 0 || stockThreshold <= 0)) {
      return const AddMedicationInvalidStock();
    }

    final String trimmedName = name.trim();
    final int? stock = trackInventory ? currentStock : null;
    final int? threshold = trackInventory ? stockThreshold : null;

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
        stockThreshold: threshold,
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
          stockThreshold: threshold,
          stockRemaining: stock,
          isActive: true,
          createdAt: DateTime.now(),
          doseTimes: savedTimes.map(MedicationMapper.toDoseTime).toList(),
        ),
      );
    });
  }
}
