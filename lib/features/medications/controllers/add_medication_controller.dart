import 'dart:async';

import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/database/data_sources/dose_times_local_data_source.dart'
    show DoseTimeInput;
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
/// unit and meal instruction, the dose times and the stock switch.
///
/// The screen is opened from one profile's page, so the recipient is fixed:
/// [_profileId] comes from the route arguments and cannot be changed here.
/// The dose times live in a [DoseTimesEditor]; this controller only forwards
/// to it, so the screen widgets use one object. [submit] returns true when
/// the medication was saved, and then closes the screen.
class AddMedicationController extends GetxController {
  AddMedicationController(this._profiles, this._medications, this._profileId);

  final ProfilesRepository _profiles;
  final MedicationsRepository _medications;
  final int? _profileId;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  /// The recipient, or null while loading or if the profile was deleted.
  final Rxn<Profile> profile = Rxn<Profile>();
  final Rx<DoseUnit> doseUnit = DoseUnit.mg.obs;
  final Rxn<MealInstruction> mealInstruction = Rxn<MealInstruction>();
  final RxBool trackInventory = false.obs;
  final RxBool isLoading = false.obs;

  final DoseTimesEditor _timesEditor = DoseTimesEditor();

  StreamSubscription<List<Profile>>? _subscription;

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
    final int? profileId = _profileId;
    final double? doseAmount = Validators.parsePositiveNumber(
      doseController.text,
    );
    if (profileId == null || doseAmount == null) {
      AppSnackbar.error(AppStrings.medsErrorProfileNotFound.tr);
      return false;
    }

    isLoading.value = true;
    try {
      final AddMedicationResult result = await _medications.addMedication(
        profileId: profileId,
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
    Profile? found;
    for (final Profile candidate in list) {
      if (candidate.id == _profileId) {
        found = candidate;
        break;
      }
    }
    profile.value = found;
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
