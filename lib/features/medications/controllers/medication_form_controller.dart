import 'dart:async';

import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/features/medications/controllers/medication_form_fields.dart';
import 'package:dose_tracker/features/medications/controllers/medication_form_result_handler.dart';
import 'package:dose_tracker/features/medications/data/models/medication.dart';
import 'package:dose_tracker/features/medications/data/models/medication_results.dart';
import 'package:dose_tracker/features/medications/data/repositories/medication_updates_repository.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MedicationFormController extends GetxController {
  MedicationFormController(
    this._profiles,
    this._medications,
    this._updates, {
    int? profileId,
    int? medicationId,
  }) : _profileId = profileId,
       _medicationId = medicationId,
       isLoadingForm = (medicationId != null).obs;

  final ProfilesRepository _profiles;
  final MedicationsRepository _medications;
  final MedicationUpdatesRepository _updates;
  int? _profileId;
  final int? _medicationId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final MedicationFormFields form = MedicationFormFields();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingForm;
  final Rxn<Profile> profile = Rxn<Profile>();

  StreamSubscription<List<Profile>>? _profileSubscription;

  bool get isEditing => _medicationId != null;

  @override
  void onInit() {
    super.onInit();
    if (isEditing) {
      unawaited(_loadMedication());
    } else {
      _listenForProfile();
    }
  }

  Future<void> _loadMedication() async {
    final Medication? medication = await _medications.findMedication(
      _medicationId!,
    );
    if (medication == null) {
      AppSnackbar.error(AppStrings.medsErrorMedicationNotFound.tr);
      Get.back<void>();
      return;
    }
    _profileId = medication.profileId;
    form.loadFrom(medication);
    _listenForProfile();
    isLoadingForm.value = false;
  }

  void _listenForProfile() {
    _profileSubscription?.cancel();
    _profileSubscription = _profiles.watchProfiles().listen(_onProfiles);
  }

  void _onProfiles(List<Profile> profiles) {
    Profile? found;
    for (final Profile candidate in profiles) {
      if (candidate.id == _profileId) {
        found = candidate;
        break;
      }
    }
    profile.value = found;
  }

  Future<bool> submit() async {
    if (isLoading.value || isLoadingForm.value) {
      return false;
    }
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }
    final double? doseAmount = form.doseAmount;
    if (doseAmount == null) {
      AppSnackbar.error(AppStrings.medsErrorProfileNotFound.tr);
      return false;
    }

    isLoading.value = true;
    try {
      if (isEditing) {
        final UpdateMedicationResult result = await _updates.updateMedication(
          medicationId: _medicationId!,
          name: form.nameController.text,
          doseAmount: doseAmount,
          doseUnit: form.doseUnit.value,
          mealInstruction: form.mealInstruction.value,
          times: form.times.toList(),
          trackInventory: form.trackInventory.value,
          currentStock: form.currentStock,
          stockThreshold: form.stockThreshold,
        );
        return MedicationFormResultHandler.handleUpdate(result);
      }
      final int? profileId = _profileId;
      if (profileId == null) {
        AppSnackbar.error(AppStrings.medsErrorProfileNotFound.tr);
        return false;
      }
      final AddMedicationResult result = await _medications.addMedication(
        profileId: profileId,
        name: form.nameController.text,
        doseAmount: doseAmount,
        doseUnit: form.doseUnit.value,
        mealInstruction: form.mealInstruction.value,
        times: form.times.toList(),
        trackInventory: form.trackInventory.value,
        currentStock: form.currentStock,
        stockThreshold: form.stockThreshold,
      );
      return MedicationFormResultHandler.handleAdd(result);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _profileSubscription?.cancel();
    form.dispose();
    super.onClose();
  }
}
