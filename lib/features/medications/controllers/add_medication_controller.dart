import 'dart:async';

import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/features/medications/controllers/medication_form_fields.dart';
import 'package:dose_tracker/features/medications/data/models/medication_results.dart';
import 'package:dose_tracker/features/medications/data/repositories/medications_repository.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddMedicationController extends GetxController {
  AddMedicationController(this._profiles, this._medications, this._profileId);

  final ProfilesRepository _profiles;
  final MedicationsRepository _medications;
  final int? _profileId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final MedicationFormFields form = MedicationFormFields();
  final RxBool isLoading = false.obs;
  final Rxn<Profile> profile = Rxn<Profile>();

  StreamSubscription<List<Profile>>? _profileSubscription;

  @override
  void onInit() {
    super.onInit();
    _profileSubscription = _profiles.watchProfiles().listen((List<Profile> list) {
      Profile? found;
      for (final Profile candidate in list) {
        if (candidate.id == _profileId) {
          found = candidate;
          break;
        }
      }
      profile.value = found;
    });
  }

  Future<bool> submit() async {
    if (isLoading.value) {
      return false;
    }
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }
    final int? profileId = _profileId;
    final double? doseAmount = form.doseAmount;
    if (profileId == null || doseAmount == null) {
      AppSnackbar.error(AppStrings.medsErrorProfileNotFound.tr);
      return false;
    }

    isLoading.value = true;
    try {
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

  @override
  void onClose() {
    _profileSubscription?.cancel();
    form.dispose();
    super.onClose();
  }
}
