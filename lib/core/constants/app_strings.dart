/// Translation KEYS only, never display text.
///
/// Widgets show text with `AppStrings.someKey.tr` (GetX). The actual English
/// and Arabic values live in `en_translations.dart` and `ar_translations.dart`,
/// and every key declared here must exist in both maps.
/// Parameters use the `@name` form: `AppStrings.validationPasswordShort.trParams({'min': '8'})`.
/// Each feature step appends its own keys under a new section header.
abstract final class AppStrings {
  // ---- Brand ----
  static const String appName = 'app_name';
  static const String appTagline = 'app_tagline';

  // ---- Common actions ----
  static const String actionNext = 'action_next';
  static const String actionSkip = 'action_skip';
  static const String actionBack = 'action_back';
  static const String actionSave = 'action_save';
  static const String actionCancel = 'action_cancel';
  static const String actionDelete = 'action_delete';
  static const String actionConfirm = 'action_confirm';
  static const String actionRetry = 'action_retry';
  static const String actionDone = 'action_done';
  static const String actionClose = 'action_close';
  static const String actionApply = 'action_apply';
  static const String actionGetStarted = 'action_get_started';

  // ---- Common states ----
  static const String stateLoading = 'state_loading';
  static const String stateErrorGeneric = 'state_error_generic';

  // ---- Validation ----
  static const String validationRequired = 'validation_required';
  static const String validationEmailInvalid = 'validation_email_invalid';
  static const String validationPasswordShort = 'validation_password_short';
  static const String validationPasswordMismatch =
      'validation_password_mismatch';
  static const String validationNameShort = 'validation_name_short';

  // ---- Accessibility labels and tooltips ----
  static const String a11yLogo = 'a11y_logo';
  static const String a11yShowPassword = 'a11y_show_password';
  static const String a11yHidePassword = 'a11y_hide_password';

  // ---- Auth (shared) ----
  static const String authLogIn = 'auth_log_in';

  // ---- Onboarding ----
  static const String onboardingFamilyTitle = 'onboarding_family_title';
  static const String onboardingFamilyBody = 'onboarding_family_body';
  static const String onboardingRemindersTitle = 'onboarding_reminders_title';
  static const String onboardingRemindersBody = 'onboarding_reminders_body';
  static const String onboardingStockTitle = 'onboarding_stock_title';
  static const String onboardingStockBody = 'onboarding_stock_body';
  static const String onboardingHaveAccount = 'onboarding_have_account';
  static const String onboardingPageIndicator = 'onboarding_page_indicator';
}
