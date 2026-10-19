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
    AppStrings.actionGetStarted: 'Get Started',

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
    AppStrings.validationNameLong: 'Name must be at most @max characters',
    // ---- Accessibility labels and tooltips ----
    AppStrings.a11yLogo: 'Dose Tracker logo',
    AppStrings.a11yShowPassword: 'Show password',
    AppStrings.a11yHidePassword: 'Hide password',

    // ---- Auth (shared) ----
    AppStrings.authLogIn: 'Log In',
    AppStrings.authSignUp: 'Sign Up',
    AppStrings.authEmailLabel: 'Email address',
    AppStrings.authEmailHint: 'care@email.com',
    AppStrings.authPasswordLabel: 'Password',
    AppStrings.authEmailTaken: 'An account with this email already exists',

    // ---- Auth: Log In ----
    AppStrings.authWelcomeBack: 'Welcome back',
    AppStrings.authLogInSubtitle:
        "Sign in to manage your family's daily medications",
    AppStrings.authForgotPasswordLink: 'Forgot Password?',
    AppStrings.authNoAccount: "Don't have an account?",
    AppStrings.authInvalidCredentials: 'Email or password is incorrect',

    // ---- Auth: Sign Up ----
    AppStrings.authCreateAccountTitle: 'Create your account',
    AppStrings.authCreateAccountSubtitle:
        'Local caregiver account for family dose management',
    AppStrings.authFullNameLabel: 'Full name',
    AppStrings.authFullNameHint: 'Alexander Wright',
    AppStrings.authConfirmPasswordLabel: 'Confirm password',
    AppStrings.authSecurityQuestionLabel: 'Security question',
    AppStrings.authSecurityAnswerLabel: 'Your answer',
    AppStrings.authSecurityAnswerHelper:
        'Used to reset your password if you forget it. Not case-sensitive.',
    AppStrings.authCreateAccountButton: 'Create Account',
    AppStrings.authHaveAccount: 'Already have an account?',

    // ---- Auth: Forgot Password ----
    AppStrings.forgotPasswordTitle: 'Reset your password',
    AppStrings.forgotPasswordEmailSubtitle:
        'Enter the email of your local account on this device.',
    AppStrings.forgotPasswordContinue: 'Continue',
    AppStrings.forgotPasswordStepIndicator: 'Step @current of @total',
    AppStrings.forgotPasswordStepVerify: 'Verify account',
    AppStrings.forgotPasswordStepNewPassword: 'New password',
    AppStrings.forgotPasswordNewTitle: 'Set a new password',
    AppStrings.forgotPasswordNewSubtitle:
        'Answer your security question, then choose a new password.',
    AppStrings.forgotPasswordNewPasswordLabel: 'New password',
    AppStrings.forgotPasswordResetButton: 'Reset Password',
    AppStrings.forgotPasswordAccountNotFound:
        'No account on this device uses this email',
    AppStrings.forgotPasswordWrongAnswer: 'That answer is not correct',
    AppStrings.forgotPasswordSuccess: 'Password updated. You can log in now.',
    AppStrings.forgotPasswordRemembered: 'Remember your password?',

    // ---- Security questions ----
    AppStrings.securityQuestionFirstSchool:
        'What was the name of your first school?',
    AppStrings.securityQuestionBirthCity: 'In which city were you born?',
    AppStrings.securityQuestionFirstPet: 'What was the name of your first pet?',
    AppStrings.securityQuestionFavoriteTeacher:
        'Who was your favorite teacher?',
    AppStrings.securityQuestionChildhoodNickname:
        'What was your childhood nickname?',

    // ---- Onboarding ----
    AppStrings.onboardingFamilyTitle:
        "Manage your whole family's medications in one place",
    AppStrings.onboardingFamilyBody:
        'Organize and track schedules, dosages, and daily adherence for '
        'everyone under one simple roof.',
    AppStrings.onboardingRemindersTitle: 'Never miss a dose',
    AppStrings.onboardingRemindersBody:
        'Get escalating reminders at dose time, plus follow-ups if a dose '
        "isn't marked taken, and see your family's monthly adherence at a "
        'glance.',
    AppStrings.onboardingStockTitle: 'Track stock & share doctor-ready reports',
    AppStrings.onboardingStockBody:
        'Get refill alerts before you run out, and generate a clean PDF '
        'report for any family member to bring to their doctor.',
    AppStrings.onboardingHaveAccount: 'Already have an account?',
    AppStrings.onboardingPageIndicator: 'Page @current of @total',

    // ---- Navigation (bottom bar tabs) ----
    AppStrings.navHome: 'Home',
    AppStrings.navSchedule: 'Schedule',
    AppStrings.navInventory: 'Inventory',
    AppStrings.navSettings: 'Settings',

    // ---- Home (empty state) and shell ----
    AppStrings.homeEmptyTitle: 'Add your first family member',
    AppStrings.homeEmptyMessage:
        'Create a profile for yourself or someone you care for, then add '
        'their medications.',
    AppStrings.homeAddProfile: 'Add family member',
    AppStrings.homeNoMedications: 'No medications yet',
    AppStrings.homeMedicationCount: '@count medications',
    AppStrings.homeNoDosesToday: 'No doses today',
    AppStrings.homeDosesProgress: '@taken of @total taken today',
    AppStrings.profileDetailTitle: 'Family member',
    AppStrings.profileTodaySection: 'Today',
    AppStrings.profileMedicationsSection: 'Medications',
    AppStrings.profileAddMedication: 'Add medication',

    // ---- Settings ----
    AppStrings.settingsLanguage: 'Language',
    AppStrings.settingsAppearance: 'Appearance',
    AppStrings.settingsComingSoon: 'Coming soon',
    AppStrings.settingsLogOut: 'Log Out',
    AppStrings.settingsLogOutTitle: 'Log out?',
    AppStrings.settingsLogOutMessage:
        'You will need to log in again. Your data stays on this device.',
    AppStrings.languageEnglishName: 'English',
    AppStrings.languageArabicName: 'العربية',

    // ---- Identity color names (accessibility labels) ----
    AppStrings.personaColorTeal: 'Teal',
    AppStrings.personaColorRose: 'Rose',
    AppStrings.personaColorOrange: 'Orange',
    AppStrings.personaColorPurple: 'Purple',
    AppStrings.personaColorBlue: 'Blue',

    // ---- Profiles: Add Profile ----
    AppStrings.profilesAddTitle: 'Add Family Member',
    AppStrings.profilesColorLabel: 'Choose a color for this profile',
    AppStrings.profilesNameLabel: 'Full name',
    AppStrings.profilesNameHint: 'For example: Mom',
    AppStrings.profileAvatarLabel: 'Avatar',
    AppStrings.profileAvatarFirstLetter: 'Use first letter',
    AppStrings.profileAvatarMan: 'Man avatar',
    AppStrings.profileAvatarWoman: 'Woman avatar',
    AppStrings.profileAvatarBoy: 'Boy avatar',
    AppStrings.profileAvatarGirl: 'Girl avatar',
    AppStrings.profileAvatarBaby: 'Baby avatar',
    AppStrings.profileAvatarGrandfather: 'Grandfather avatar',
    AppStrings.profileAvatarGrandmother: 'Grandmother avatar',
    AppStrings.profileAvatarPerson: 'Person avatar',
    AppStrings.profileAvatarBeard: 'Bearded person avatar',
    AppStrings.profileAvatarBlond: 'Blond person avatar',
    AppStrings.profileAvatarCat: 'Cat avatar',
    AppStrings.profileAvatarDog: 'Dog avatar',

    // ---- Medications: Add Medication ----
    AppStrings.medsAddTitle: 'Add New Medication',
    AppStrings.medsRecipientLabel: 'Dose recipient',
    AppStrings.medsNameLabel: 'Medication / supplement name',
    AppStrings.medsNameHint: 'For example: Metformin',
    AppStrings.medsDoseLabel: 'Dose amount & unit',
    AppStrings.medsDoseHint: '500',
    AppStrings.medsUnitMg: 'mg',
    AppStrings.medsUnitIu: 'IU',
    AppStrings.medsUnitMl: 'ml',
    AppStrings.medsUnitPills: 'pills',
    AppStrings.medsFrequencyTitle: 'Daily frequency',
    AppStrings.medsFrequencySubtitle: 'Auto-distributed across the day',
    AppStrings.medsFrequencyUnit: 'times',
    AppStrings.medsScheduleTitle: 'Intake schedule',
    AppStrings.medsAddTime: 'Add another time',
    AppStrings.medsEditTimeTitle: 'Edit dose time',
    AppStrings.medsQuantityLabel: 'Amount per dose',
    AppStrings.medsQuantitySummary: 'Amount: @count',
    AppStrings.medsMealTitle: 'Meal instruction',
    AppStrings.medsMealBefore: 'Before meal',
    AppStrings.medsMealWith: 'With meal',
    AppStrings.medsMealAfter: 'After meal',
    AppStrings.medsInventoryTitle: 'Track inventory & stock',
    AppStrings.medsInventorySubtitle: 'Decrease the count on taken doses',
    AppStrings.medsStockLabel: 'Current stock',
    AppStrings.medsStockNote:
        "You'll get a refill alert when your stock runs low.",
    AppStrings.medsSave: 'Save medication schedule',
    AppStrings.medsSaved: 'Medication added',
    AppStrings.medsErrorProfileNotFound: 'This family member no longer exists.',
    AppStrings.medsErrorInvalidSchedule:
        'Check the dose times: each time must be different and each amount '
        'above zero.',
    AppStrings.medsErrorInvalidStock:
        'Enter a current stock above zero, or turn tracking off.',
    AppStrings.validationNumberInvalid: 'Enter a number above zero',
    AppStrings.a11yFrequencyIncrease: 'Increase daily frequency',
    AppStrings.a11yFrequencyDecrease: 'Decrease daily frequency',
    AppStrings.a11yEditTime: 'Edit dose time',
    AppStrings.a11yRemoveTime: 'Remove dose time',

    // ---- Schedule ----
    AppStrings.scheduleToday: 'Today',
    AppStrings.scheduleDoseTaken: 'Dose taken',
    AppStrings.scheduleConfirmAll: 'Confirm all',
    AppStrings.scheduleUndo: 'Undo',
    AppStrings.scheduleAllDone: 'All done for today',
    AppStrings.scheduleTakenProgress: '@taken of @total taken',
    AppStrings.scheduleEmptyTitle: 'No doses today',
    AppStrings.scheduleEmptyMessage:
        'Add a medication and its doses will show up here.',
    AppStrings.scheduleStateMissed: 'Missed',
    AppStrings.scheduleSkipTitle: 'Skip this dose?',
    AppStrings.scheduleSkipReasonLabel: 'Reason (optional)',
    AppStrings.scheduleSkipReasonHint: 'For example: felt unwell',
    AppStrings.scheduleStateSkipped: 'Skipped',
    AppStrings.a11yMarkTaken: 'Mark dose as taken',
    AppStrings.a11yUndoTaken: 'Undo taken dose',

    // ---- Inventory ----
    AppStrings.inventoryTitle: 'Medicine Cabinet',
    AppStrings.inventorySummaryTitle: 'Total stock',
    AppStrings.inventorySummaryNote: 'Across all tracked medications',
    AppStrings.inventorySectionTitle: 'Medications & inventory',
    AppStrings.inventoryLeft: '@count left',
    AppStrings.inventoryTotal: 'Total: @count',
    AppStrings.inventoryNotTracked: 'Stock tracking is off',
    AppStrings.inventoryPaused: 'Paused',
    AppStrings.inventoryLowStock: 'Low stock',
    AppStrings.inventoryRefillTitle: 'Refill reminder',
    AppStrings.inventoryRefillMessage: 'Medications running low: @count',
    AppStrings.inventoryRefillShowAll: 'Tap to show all medications',
    AppStrings.inventoryEmptyTitle: 'No medications yet',
    AppStrings.inventoryEmptyMessage:
        'Add a medication to follow its stock here.',
    AppStrings.inventoryRestockTitle: 'Refill stock',
    AppStrings.inventoryRestockLabel: 'Count after refill',
    AppStrings.inventoryRestocked: 'Stock updated',

    // ---- Notifications ----
    AppStrings.notifChannelName: 'Dose reminders',
    AppStrings.notifChannelDescription:
        'Reminders for medication doses and low stock.',
    AppStrings.notifDoseTitle: 'Time for your dose',
    AppStrings.notifDoseBody: '@medication for @profile',
    AppStrings.notifRepeatBody: 'Not recorded yet: @medication for @profile',
    AppStrings.notifLowStockTitle: 'Running low',
    AppStrings.notifLowStockBody: '@medication for @profile: @count left',
    AppStrings.notifSettingsRowTitle: 'Notifications',
    AppStrings.notifSettingsRowSubtitle: 'Dose reminders & repeats',
    AppStrings.notifStateOn: 'On',
    AppStrings.notifStateOff: 'Off',
    AppStrings.notifSheetTitle: 'Notifications',
    AppStrings.notifEnableLabel: 'Dose reminders',
    AppStrings.notifEnableSubtitle: 'Get a notification when a dose is due',
    AppStrings.notifRepeatTitle: 'Repeat if not recorded',
    AppStrings.notifRepeatOff: 'Off',
    AppStrings.notifRepeatThirtyMinutes: 'Every 30 min',
    AppStrings.notifRepeatHour: 'Every hour',
    AppStrings.notifRepeatTwoHours: 'Every 2 hours',
    AppStrings.notifPermissionTitle: 'Permission',
    AppStrings.notifPermissionGranted: 'Notifications are allowed',
    AppStrings.notifPermissionDenied: 'Notifications are not allowed',
    AppStrings.notifPermissionAllow: 'Allow notifications',

    // ---- Profiles: Edit and delete ----
    AppStrings.profilesEditTitle: 'Edit Profile',
    AppStrings.profilesSaved: 'Changes saved',
    AppStrings.profilesNotFound: 'This profile no longer exists.',
    AppStrings.profilesDeleteAction: 'Delete profile',
    AppStrings.profilesDeleteTitle: 'Delete this profile?',
    AppStrings.profilesDeleteMessage:
        '@name and all of their medications and dose history will be '
        'deleted. This cannot be undone.',
    AppStrings.profilesDeleted: 'Profile deleted',

    // ---- Report empty state ----
    AppStrings.calendarEmptyTitle: 'No family members yet',
    AppStrings.calendarEmptyMessage:
        'Add a family member and their medications to follow adherence here.',

    // ---- Doctor's report ----
    AppStrings.reportTitle: "Doctor's Report",
    AppStrings.reportSettingsRowTitle: "Doctor's report",
    AppStrings.reportPatientLabel: 'Patient',
    AppStrings.reportIntervalTitle: 'Report interval',
    AppStrings.reportLast7: 'Last 7 days',
    AppStrings.reportLast30: 'Last 30 days',
    AppStrings.reportCustom: 'Custom range',
    AppStrings.reportRangeValue: '@from to @to',
    AppStrings.reportMedicationTitle: 'Medication',
    AppStrings.reportAllMedications: 'All medications',
    AppStrings.reportOverviewTitle: 'Adherence overview',
    AppStrings.reportOverviewSummary: '@taken of @total due doses were taken',
    AppStrings.reportAdherenceBadge: '@percent adherence',
    AppStrings.reportStatMissed: 'Missed or skipped',
    AppStrings.reportStatLate: 'Taken late',
    AppStrings.reportDetailsTitle: 'Prescription details',
    AppStrings.reportColumnPrescribed: 'Prescribed',
    AppStrings.reportColumnTaken: 'Taken',
    AppStrings.reportColumnMissed: 'Missed',
    AppStrings.reportMissedTitle: 'Doses not taken',
    AppStrings.reportMissedNone: 'No missed or skipped doses in this range.',
    AppStrings.reportSkippedReason: 'Skipped: @reason',
    AppStrings.reportNotesTitle: 'Additional notes for the doctor',
    AppStrings.reportNotesOptional: 'Optional',
    AppStrings.reportNotesHint: 'Add observations, side effects or questions…',
    AppStrings.reportGenerate: 'Generate PDF report',
    AppStrings.reportEmptyTitle: 'No doses in this range',
    AppStrings.reportEmptyMessage:
        'Pick another range or another family member.',
    AppStrings.reportGeneratedOn: 'Generated on @date',
    AppStrings.reportFooter:
        'Generated by Dose Tracker from the dose log kept in the app.',
    AppStrings.reportFailed: 'Could not create the report.',
  };
}
