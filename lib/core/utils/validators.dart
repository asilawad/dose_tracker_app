import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:get/get.dart';

/// Form validators. Each returns a translated error message, or null when
/// the value is valid, which is the contract `TextFormField.validator` expects.
/// Limits come from [AppSizes]; messages come from translations.
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static const int _arabicIndicZero = 0x0660;
  static const int _asciiZero = 0x30;
  static const int _digitCount = 10;
  static const int _arabicDecimalSeparator = 0x066B;
  static const int _comma = 0x2C;

  /// Reads a number above zero, accepting Arabic-Indic digits and a comma or
  /// Arabic decimal separator. Returns null when it is not such a number.
  static double? parsePositiveNumber(String? value) {
    if (value == null) {
      return null;
    }
    final StringBuffer buffer = StringBuffer();
    for (final int unit in value.trim().codeUnits) {
      if (unit >= _arabicIndicZero && unit < _arabicIndicZero + _digitCount) {
        buffer.writeCharCode(_asciiZero + unit - _arabicIndicZero);
      } else if (unit == _arabicDecimalSeparator || unit == _comma) {
        buffer.write('.');
      } else {
        buffer.writeCharCode(unit);
      }
    }
    final double? parsed = double.tryParse(buffer.toString());
    if (parsed == null || !parsed.isFinite || parsed <= 0) {
      return null;
    }
    return parsed;
  }

  /// Like [parsePositiveNumber] but only whole numbers are accepted.
  static int? parsePositiveInt(String? value) {
    final double? parsed = parsePositiveNumber(value);
    if (parsed == null || parsed != parsed.truncateToDouble()) {
      return null;
    }
    return parsed.toInt();
  }

  static String? positiveNumber(String? value) {
    final String? missing = required(value);
    if (missing != null) {
      return missing;
    }
    if (parsePositiveNumber(value) == null) {
      return AppStrings.validationNumberInvalid.tr;
    }
    return null;
  }

  static String? positiveInteger(String? value) {
    final String? missing = required(value);
    if (missing != null) {
      return missing;
    }
    if (parsePositiveInt(value) == null) {
      return AppStrings.validationNumberInvalid.tr;
    }
    return null;
  }

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
    if (value.trim().length > AppSizes.nameMaxLength) {
      return AppStrings.validationNameLong.trParams(<String, String>{
        'max': AppSizes.nameMaxLength.toString(),
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
