import 'dart:async';

import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/medications/controllers/dose_times_editor.dart';
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
/// The dose times live in a [DoseTimesEditor]; this controller only forwards
/// to it, so the screen widgets use one object. The first profile is chosen
/// by default. [submit] returns true when the medication was saved, and then
/// closes the screen.
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
  final RxBool trackInventory = false.obs;
  final RxBool isLoading = false.obs;

  final DoseTimesEditor _timesEditor = DoseTimesEditor();

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

  RxList<DoseTimeInput> get times => _timesEditor.times;

  int get frequency => _timesEditor.frequency;

  bool get canIncreaseFrequency => _timesEditor.canIncrease;

  bool get canDecreaseFrequency => _timesEditor.canDecrease;

  @override
  void onInit() {
    super.onInit();
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

  void increaseFrequency() => _timesEditor.increase();

  void decreaseFrequency() => _timesEditor.decrease();

  void addTime() => _timesEditor.addTime();

  void removeTime(int index) => _timesEditor.removeTime(index);

  /// Changes one time. Returns false, and changes nothing, when another time
  /// already uses the same minute or the index is invalid.
  bool updateTime({
    required int index,
    required int minuteOfDay,
    required double quantity,
  }) {
    return _timesEditor.updateTime(
      index: index,
      minuteOfDay: minuteOfDay,
      quantity: quantity,
    );
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

  @override
  void onClose() {
    _subscription?.cancel();
    nameController.dispose();
    doseController.dispose();
    stockController.dispose();
    super.onClose();
  }
}
