import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/profiles/data/models/profile_results.dart';
import 'package:dose_tracker/features/profiles/data/repositories/profiles_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// State and actions of the Add Profile screen: the name field, the chosen
/// identity color and the loading flag.
///
/// Every identity color is free to pick, with no restriction. [submit]
/// returns true when the profile was saved, and then closes the screen so
/// the user lands back where they came from.
class AddProfileController extends GetxController {
  AddProfileController(this._profiles);

  final ProfilesRepository _profiles;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  final Rx<PersonaColor> selectedColor = PersonaColor.values.first.obs;
  final RxBool isLoading = false.obs;

  String? validateName(String? value) => Validators.name(value);

  void selectColor(PersonaColor color) {
    selectedColor.value = color;
  }

  Future<bool> submit() async {
    if (isLoading.value) {
      return false;
    }
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    isLoading.value = true;
    try {
      final AddProfileResult result = await _profiles.addProfile(
        name: nameController.text,
        personaColor: selectedColor.value,
      );
      switch (result) {
        case AddProfileSuccess():
          Get.back<void>();
          return true;
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
