import 'dart:async';

import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/core/utils/dose_scheduler.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:dose_tracker/features/medications/data/models/medication_results.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// State and actions of the Add Medication screen: the text fields, the
/// chosen profile, unit and meal instruction, the dose times and the stock
/// switch.
///
/// The number of times is always the length of [times]. The stepper
/// redistributes the times evenly over 24 hours (which discards manual
/// edits), while adding, removing or editing one time keeps the others as
/// they are. The first profile is chosen by default. [submit] returns true
/// when the medication was saved, and then closes the screen.
class AddMedicationController extends GetxController {
  AddMedicationController(this._profiles, this._medications);

  final ProfilesRepository _profiles;
  final MedicationsRepository _medications;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  final RxList<Profile> profiles = <Profile>[].obs;
  final Rxn<int> selectedProfileId = Rxn<int>();
  final Rx<DoseUnit> doseUnit = DoseUnit.mg.obs;
  final Rxn<MealInstruction> mealInstruction = Rxn<MealInstruction>();
  final RxList<DoseTimeInput> times = <DoseTimeInput>[].obs;
  final RxBool trackInventory = false.obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<List<Profile>>? _subscription;

  /// The chosen profile, or null while the list is empty or loading.
  Profile? get selectedProfile {
    final int? id = selectedProfileId.value;
    for (final Profile profile in profiles) {
      if (profile.id == id) {
        return profile;
      }
    }
    return null;
  }

  int get frequency => times.length;

  bool get canIncreaseFrequency =>
      times.length < DoseScheduler.maxDailyFrequency;

  bool get canDecreaseFrequency =>
      times.length > DoseScheduler.minDailyFrequency;

  @override
  void onInit() {
    super.onInit();
    _setDistributedTimes(DoseScheduler.defaultFrequency);
    _subscription = _profiles.watchProfiles().listen(_onProfiles);
  }

  String? validateName(String? value) => Validators.required(value);

  String? validateDose(String? value) => Validators.positiveNumber(value);

  String? validateStock(String? value) {
    return trackInventory.value ? Validators.positiveInteger(value) : null;
  }

  void selectProfile(int id) {
    selectedProfileId.value = id;
  }

  void selectUnit(DoseUnit unit) {
    doseUnit.value = unit;
  }

  /// Tapping the chosen meal option again clears it (the field is optional).
  void selectMeal(MealInstruction instruction) {
    mealInstruction.value = mealInstruction.value == instruction
        ? null
        : instruction;
  }

  void setTrackInventory(bool value) {
    trackInventory.value = value;
  }

  void increaseFrequency() {
    if (canIncreaseFrequency) {
      _setDistributedTimes(frequency + 1);
    }
  }

  void decreaseFrequency() {
    if (canDecreaseFrequency) {
      _setDistributedTimes(frequency - 1);
    }
  }

  /// Adds one time after the latest one, keeping the other times as they are.
  void addTime() {
    if (!canIncreaseFrequency) {
      return;
    }
    times.add((
      minuteOfDay: DoseScheduler.nextFreeMinute(
        times.map((DoseTimeInput time) => time.minuteOfDay),
      ),
      quantity: DoseScheduler.defaultQuantity,
    ));
    _sortTimes();
  }

  void removeTime(int index) {
    if (!canDecreaseFrequency || index < 0 || index >= times.length) {
      return;
    }
    times.removeAt(index);
  }

  /// Changes one time. Returns false, and changes nothing, when another time
  /// already uses the same minute or the index is invalid.
  bool updateTime({
    required int index,
    required int minuteOfDay,
    required double quantity,
  }) {
    if (index < 0 || index >= times.length) {
      return false;
    }
    for (int other = 0; other < times.length; other++) {
      if (other != index && times[other].minuteOfDay == minuteOfDay) {
        return false;
      }
    }
    times[index] = (minuteOfDay: minuteOfDay, quantity: quantity);
    _sortTimes();
    return true;
  }

  Future<bool> submit() async {
    if (isLoading.value) {
      return false;
    }
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }
    final Profile? profile = selectedProfile;
    final double? doseAmount = Validators.parsePositiveNumber(
      doseController.text,
    );
    if (profile == null || doseAmount == null) {
      AppSnackbar.error(AppStrings.medsNoProfiles.tr);
      return false;
    }

    isLoading.value = true;
    try {
      final AddMedicationResult result = await _medications.addMedication(
        profileId: profile.id,
        name: nameController.text,
        doseAmount: doseAmount,
        doseUnit: doseUnit.value,
        mealInstruction: mealInstruction.value,
        times: times.toList(),
        trackInventory: trackInventory.value,
        currentStock: Validators.parsePositiveInt(stockController.text),
      );
      switch (result) {
        case AddMedicationSuccess():
          Get.back<void>();
          AppSnackbar.success(AppStrings.medsSaved.tr);
          return true;
        case AddMedicationProfileNotFound():
          AppSnackbar.error(AppStrings.medsErrorProfileNotFound.tr);
          return false;
        case AddMedicationInvalidSchedule():
          AppSnackbar.error(AppStrings.medsErrorInvalidSchedule.tr);
          return false;
        case AddMedicationInvalidStock():
          AppSnackbar.error(AppStrings.medsErrorInvalidStock.tr);
          return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _onProfiles(List<Profile> list) {
    profiles.assignAll(list);
    final bool stillExists = list.any(
      (Profile profile) => profile.id == selectedProfileId.value,
    );
    if (!stillExists) {
      selectedProfileId.value = list.isEmpty ? null : list.first.id;
    }
  }

  void _setDistributedTimes(int count) {
    times.assignAll(
      DoseScheduler.distribute(count).map(
        (int minute) =>
            (minuteOfDay: minute, quantity: DoseScheduler.defaultQuantity),
      ),
    );
  }

  void _sortTimes() {
    final List<DoseTimeInput> sorted = times.toList()
      ..sort(
        (DoseTimeInput a, DoseTimeInput b) =>
            a.minuteOfDay.compareTo(b.minuteOfDay),
      );
    times.assignAll(sorted);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    nameController.dispose();
    doseController.dispose();
    stockController.dispose();
    super.onClose();
  }
}
