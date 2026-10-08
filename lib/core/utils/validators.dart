import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:get/get.dart';

/// Form validators. Each returns a translated error message, or null when
/// the value is valid, which is the contract `TextFormField.validator` expects.
/// Limits come from [AppSizes]; messages come from translations.
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationRequired.tr;
    }
    return null;
  }

  static String? name(String? value) {
    final String? missing = required(value);
    if (missing != null) {
      return missing;
    }
    if (value!.trim().length < AppSizes.nameMinLength) {
      return AppStrings.validationNameShort.trParams(<String, String>{
        'min': AppSizes.nameMinLength.toString(),
      });
    }
    return null;
  }

  static String? email(String? value) {
    final String? missing = required(value);
    if (missing != null) {
      return missing;
    }
    if (!_emailPattern.hasMatch(value!.trim())) {
      return AppStrings.validationEmailInvalid.tr;
    }
    return null;
  }

  static String? password(String? value) {
    final String? missing = required(value);
    if (missing != null) {
      return missing;
    }
    if (value!.length < AppSizes.passwordMinLength) {
      return AppStrings.validationPasswordShort.trParams(<String, String>{
        'min': AppSizes.passwordMinLength.toString(),
      });
    }
    return null;
  }

  /// Use as: `validator: (v) => Validators.confirmPassword(v, passwordCtrl.text)`.
  static String? confirmPassword(String? value, String original) {
    final String? missing = required(value);
    if (missing != null) {
      return missing;
    }
    if (value != original) {
      return AppStrings.validationPasswordMismatch.tr;
    }
    return null;
  }
}
