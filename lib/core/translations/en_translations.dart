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
    AppStrings.a11yAddMedication: 'Add medication',

    // ---- Settings ----
    AppStrings.settingsLanguage: 'Language',
    AppStrings.settingsAppearance: 'Appearance',
    AppStrings.settingsComingSoon: 'Coming soon',
    AppStrings.settingsLogOut: 'Log Out',
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

    // ---- Medications: Add Medication ----
    AppStrings.medsAddTitle: 'Add New Medication',
    AppStrings.medsRecipientLabel: 'Dose recipient',
    AppStrings.medsRecipientChange: 'Change',
    AppStrings.medsRecipientSheetTitle: 'Who is this medication for?',
    AppStrings.medsNoProfiles: 'Add a family member first',
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
        "You'll get a refill alert when 10% of your stock is left.",
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
  };
}
