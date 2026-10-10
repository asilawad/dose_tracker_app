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
  static const String validationNameLong = 'validation_name_long';
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

  // ---- Auth: Forgot Password ----
  static const String forgotPasswordTitle = 'forgot_password_title';
  static const String forgotPasswordEmailSubtitle =
      'forgot_password_email_subtitle';
  static const String forgotPasswordContinue = 'forgot_password_continue';
  static const String forgotPasswordStepIndicator =
      'forgot_password_step_indicator';
  static const String forgotPasswordStepVerify = 'forgot_password_step_verify';
  static const String forgotPasswordStepNewPassword =
      'forgot_password_step_new_password';
  static const String forgotPasswordNewTitle = 'forgot_password_new_title';
  static const String forgotPasswordNewSubtitle =
      'forgot_password_new_subtitle';
  static const String forgotPasswordNewPasswordLabel =
      'forgot_password_new_password_label';
  static const String forgotPasswordResetButton =
      'forgot_password_reset_button';
  static const String forgotPasswordAccountNotFound =
      'forgot_password_account_not_found';
  static const String forgotPasswordWrongAnswer =
      'forgot_password_wrong_answer';
  static const String forgotPasswordSuccess = 'forgot_password_success';
  static const String forgotPasswordRemembered = 'forgot_password_remembered';

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

  // ---- Navigation (bottom bar tabs) ----
  static const String navHome = 'nav_home';
  static const String navSchedule = 'nav_schedule';
  static const String navInventory = 'nav_inventory';
  static const String navSettings = 'nav_settings';

  // ---- Home (empty state) and shell ----
  static const String homeEmptyTitle = 'home_empty_title';
  static const String homeEmptyMessage = 'home_empty_message';
  static const String homeAddProfile = 'home_add_profile';
  static const String a11yAddMedication = 'a11y_add_medication';

  // ---- Settings ----
  static const String settingsLanguage = 'settings_language';
  static const String settingsAppearance = 'settings_appearance';
  static const String settingsComingSoon = 'settings_coming_soon';
  static const String settingsLogOut = 'settings_log_out';
  static const String languageEnglishName = 'language_english_name';
  static const String languageArabicName = 'language_arabic_name';

  // ---- Identity color names (accessibility labels) ----
  static const String personaColorTeal = 'persona_color_teal';
  static const String personaColorRose = 'persona_color_rose';
  static const String personaColorOrange = 'persona_color_orange';
  static const String personaColorPurple = 'persona_color_purple';
  static const String personaColorBlue = 'persona_color_blue';

  // ---- Profiles: Add Profile ----
  static const String profilesAddTitle = 'profiles_add_title';
  static const String profilesColorLabel = 'profiles_color_label';
  static const String profilesNameLabel = 'profiles_name_label';
  static const String profilesNameHint = 'profiles_name_hint';

  // ---- Medications: Add Medication ----
  static const String medsAddTitle = 'meds_add_title';
  static const String medsRecipientLabel = 'meds_recipient_label';
  static const String medsRecipientChange = 'meds_recipient_change';
  static const String medsRecipientSheetTitle = 'meds_recipient_sheet_title';
  static const String medsNoProfiles = 'meds_no_profiles';
  static const String medsNameLabel = 'meds_name_label';
  static const String medsNameHint = 'meds_name_hint';
  static const String medsDoseLabel = 'meds_dose_label';
  static const String medsDoseHint = 'meds_dose_hint';
  static const String medsUnitMg = 'meds_unit_mg';
  static const String medsUnitIu = 'meds_unit_iu';
  static const String medsUnitMl = 'meds_unit_ml';
  static const String medsUnitPills = 'meds_unit_pills';
  static const String medsFrequencyTitle = 'meds_frequency_title';
  static const String medsFrequencySubtitle = 'meds_frequency_subtitle';
  static const String medsFrequencyUnit = 'meds_frequency_unit';
  static const String medsScheduleTitle = 'meds_schedule_title';
  static const String medsAddTime = 'meds_add_time';
  static const String medsEditTimeTitle = 'meds_edit_time_title';
  static const String medsQuantityLabel = 'meds_quantity_label';
  static const String medsQuantitySummary = 'meds_quantity_summary';
  static const String medsMealTitle = 'meds_meal_title';
  static const String medsMealBefore = 'meds_meal_before';
  static const String medsMealWith = 'meds_meal_with';
  static const String medsMealAfter = 'meds_meal_after';
  static const String medsInventoryTitle = 'meds_inventory_title';
  static const String medsInventorySubtitle = 'meds_inventory_subtitle';
  static const String medsStockLabel = 'meds_stock_label';
  static const String medsStockNote = 'meds_stock_note';
  static const String medsSave = 'meds_save';
  static const String medsSaved = 'meds_saved';
  static const String medsErrorProfileNotFound = 'meds_error_profile_not_found';
  static const String medsErrorInvalidSchedule = 'meds_error_invalid_schedule';
  static const String medsErrorInvalidStock = 'meds_error_invalid_stock';
  static const String validationNumberInvalid = 'validation_number_invalid';
  static const String a11yFrequencyIncrease = 'a11y_frequency_increase';
  static const String a11yFrequencyDecrease = 'a11y_frequency_decrease';
  static const String a11yEditTime = 'a11y_edit_time';
  static const String a11yRemoveTime = 'a11y_remove_time';

  // ---- Schedule ----
  static const String scheduleToday = 'schedule_today';
  static const String scheduleEmptyTitle = 'schedule_empty_title';
  static const String scheduleEmptyMessage = 'schedule_empty_message';
  static const String scheduleFutureNote = 'schedule_future_note';
  static const String scheduleStatePending = 'schedule_state_pending';
  static const String scheduleStateTaken = 'schedule_state_taken';
  static const String scheduleStateTakenLate = 'schedule_state_taken_late';
  static const String scheduleStateSkipped = 'schedule_state_skipped';
  static const String scheduleStateMissed = 'schedule_state_missed';
  static const String scheduleSkipTitle = 'schedule_skip_title';
  static const String scheduleSkipReasonLabel = 'schedule_skip_reason_label';
  static const String scheduleSkipReasonHint = 'schedule_skip_reason_hint';
  static const String a11yMarkTaken = 'a11y_mark_taken';
  static const String a11yUndoTaken = 'a11y_undo_taken';
  static const String a11yPreviousWeek = 'a11y_previous_week';
  static const String a11yNextWeek = 'a11y_next_week';
}
