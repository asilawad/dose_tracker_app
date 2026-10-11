import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/profiles/data/models/profile.dart';
import 'package:dose_tracker/features/profiles/data/models/profile_results.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// State and actions of the Edit Profile screen: the name field, the chosen
/// identity color, and the save and delete actions of one profile.
///
/// The screen receives only the profile's id; the controller loads the
/// profile itself. When the profile cannot be found (for example it was
/// deleted meanwhile), it shows an error and closes the screen. [submit]
/// and [delete] return true when they worked, and then close the screen.
class EditProfileController extends GetxController {
  EditProfileController(this._profiles, this._profileId);

  final ProfilesRepository _profiles;
  final int? _profileId;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  final Rx<PersonaColor> selectedColor = PersonaColor.values.first.obs;
  final RxBool isLoadingProfile = true.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  String? validateName(String? value) => Validators.name(value);

  void selectColor(PersonaColor color) {
    selectedColor.value = color;
  }

  Future<bool> submit() async {
    final int? id = _profileId;
    if (id == null || isLoading.value || isLoadingProfile.value) {
      return false;
    }
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    isLoading.value = true;
    try {
      final UpdateProfileResult result = await _profiles.updateProfile(
        id: id,
        name: nameController.text,
        personaColor: selectedColor.value,
      );
      switch (result) {
        case UpdateProfileSuccess():
          Get.back<void>();
          AppSnackbar.success(AppStrings.profilesSaved.tr);
          return true;
        case UpdateProfileNotFound():
          AppSnackbar.error(AppStrings.profilesNotFound.tr);
          return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Deletes the profile with its medications and history. The screen asks
  /// the user to confirm before calling this.
  Future<bool> delete() async {
    final int? id = _profileId;
    if (id == null || isLoading.value) {
      return false;
    }

    isLoading.value = true;
    try {
      final DeleteProfileResult result = await _profiles.deleteProfile(id);
      switch (result) {
        case DeleteProfileSuccess():
          Get.back<void>();
          AppSnackbar.success(AppStrings.profilesDeleted.tr);
          return true;
        case DeleteProfileNotFound():
          AppSnackbar.error(AppStrings.profilesNotFound.tr);
          return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _load() async {
    final int? id = _profileId;
    final Profile? profile = id == null
        ? null
        : await _profiles.findProfile(id);
    if (profile == null) {
      AppSnackbar.error(AppStrings.profilesNotFound.tr);
      Get.back<void>();
      return;
    }
    nameController.text = profile.name;
    selectedColor.value = profile.personaColor;
    isLoadingProfile.value = false;
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
