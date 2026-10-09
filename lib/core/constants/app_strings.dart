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
  static const String authSignUp = 'auth_sign_up';
  static const String authEmailLabel = 'auth_email_label';
  static const String authEmailHint = 'auth_email_hint';
  static const String authPasswordLabel = 'auth_password_label';
  static const String authEmailTaken = 'auth_email_taken';

  // ---- Auth: Log In ----
  static const String authWelcomeBack = 'auth_welcome_back';
  static const String authLogInSubtitle = 'auth_log_in_subtitle';
  static const String authForgotPasswordLink = 'auth_forgot_password_link';
  static const String authNoAccount = 'auth_no_account';
  static const String authInvalidCredentials = 'auth_invalid_credentials';

  // ---- Auth: Sign Up ----
  static const String authCreateAccountTitle = 'auth_create_account_title';
  static const String authCreateAccountSubtitle =
      'auth_create_account_subtitle';
  static const String authFullNameLabel = 'auth_full_name_label';
  static const String authFullNameHint = 'auth_full_name_hint';
  static const String authConfirmPasswordLabel = 'auth_confirm_password_label';
  static const String authSecurityQuestionLabel =
      'auth_security_question_label';
  static const String authSecurityAnswerLabel = 'auth_security_answer_label';
  static const String authSecurityAnswerHelper = 'auth_security_answer_helper';
  static const String authCreateAccountButton = 'auth_create_account_button';
  static const String authHaveAccount = 'auth_have_account';

  // ---- Security questions (chosen at Sign Up, used to reset a password) ----
  static const String securityQuestionFirstSchool =
      'security_question_first_school';
  static const String securityQuestionBirthCity =
      'security_question_birth_city';
  static const String securityQuestionFirstPet = 'security_question_first_pet';
  static const String securityQuestionFavoriteTeacher =
      'security_question_favorite_teacher';
  static const String securityQuestionChildhoodNickname =
      'security_question_childhood_nickname';

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
