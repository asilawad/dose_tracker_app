import 'package:dose_tracker/core/constants/app_strings.dart';

/// English display text. Keys come from [AppStrings], so a typo in a key
/// is a compile error instead of a missing translation. Every key in
/// [AppStrings] must appear here and in the Arabic map.
abstract final class EnTranslations {
  static const Map<String, String> values = <String, String>{
    // ---- Brand ----
    AppStrings.appName: 'Dose Tracker',
    AppStrings.appTagline: 'Family medication, organized.',

    // ---- Common actions ----
    AppStrings.actionNext: 'Next',
    AppStrings.actionSkip: 'Skip',
    AppStrings.actionBack: 'Back',
    AppStrings.actionSave: 'Save',
    AppStrings.actionCancel: 'Cancel',
    AppStrings.actionDelete: 'Delete',
    AppStrings.actionConfirm: 'Confirm',
    AppStrings.actionRetry: 'Try again',
    AppStrings.actionDone: 'Done',
    AppStrings.actionClose: 'Close',
    AppStrings.actionApply: 'Apply',

    // ---- Common states ----
    AppStrings.stateLoading: 'Loading...',
    AppStrings.stateErrorGeneric: 'Something went wrong. Please try again.',

    // ---- Validation ----
    AppStrings.validationRequired: 'This field is required',
    AppStrings.validationEmailInvalid: 'Enter a valid email address',
    AppStrings.validationPasswordShort:
        'Password must be at least @min characters',
    AppStrings.validationPasswordMismatch: 'Passwords do not match',
    AppStrings.validationNameShort: 'Name must be at least @min characters',

    // ---- Accessibility labels and tooltips ----
    AppStrings.a11yLogo: 'Dose Tracker logo',
    AppStrings.a11yShowPassword: 'Show password',
    AppStrings.a11yHidePassword: 'Hide password',
  };
}
