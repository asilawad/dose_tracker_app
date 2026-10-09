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
  };
}
