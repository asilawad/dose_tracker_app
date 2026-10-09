import 'package:dose_tracker/core/constants/app_strings.dart';

/// Arabic display text. Must contain exactly the same keys as
/// `EnTranslations`. Placeholders such as @min are kept as-is.
abstract final class ArTranslations {
  static const Map<String, String> values = <String, String>{
    // ---- Brand ----
    AppStrings.appName: 'متتبع الجرعات',
    AppStrings.appTagline: 'أدوية العائلة، منظّمة.',

    // ---- Common actions ----
    AppStrings.actionNext: 'التالي',
    AppStrings.actionSkip: 'تخطي',
    AppStrings.actionBack: 'رجوع',
    AppStrings.actionSave: 'حفظ',
    AppStrings.actionCancel: 'إلغاء',
    AppStrings.actionDelete: 'حذف',
    AppStrings.actionConfirm: 'تأكيد',
    AppStrings.actionRetry: 'إعادة المحاولة',
    AppStrings.actionDone: 'تم',
    AppStrings.actionClose: 'إغلاق',
    AppStrings.actionApply: 'تطبيق',
    AppStrings.actionGetStarted: 'ابدأ الآن',

    // ---- Common states ----
    AppStrings.stateLoading: 'جارٍ التحميل...',
    AppStrings.stateErrorGeneric: 'حدث خطأ ما. حاول مرة أخرى.',

    // ---- Validation ----
    AppStrings.validationRequired: 'هذا الحقل مطلوب',
    AppStrings.validationEmailInvalid: 'أدخل بريداً إلكترونياً صحيحاً',
    AppStrings.validationPasswordShort:
        'يجب أن تتكون كلمة المرور من @min أحرف على الأقل',
    AppStrings.validationPasswordMismatch: 'كلمتا المرور غير متطابقتين',
    AppStrings.validationNameShort: 'يجب أن يتكون الاسم من @min أحرف على الأقل',

    // ---- Accessibility labels and tooltips ----
    AppStrings.a11yLogo: 'شعار متتبع الجرعات',
    AppStrings.a11yShowPassword: 'إظهار كلمة المرور',
    AppStrings.a11yHidePassword: 'إخفاء كلمة المرور',

    // ---- Auth (shared) ----
    AppStrings.authLogIn: 'تسجيل الدخول',
    AppStrings.authSignUp: 'إنشاء حساب',
    AppStrings.authEmailLabel: 'البريد الإلكتروني',
    AppStrings.authEmailHint: 'care@email.com',
    AppStrings.authPasswordLabel: 'كلمة المرور',
    AppStrings.authEmailTaken: 'يوجد حساب بهذا البريد الإلكتروني بالفعل',

    // ---- Auth: Log In ----
    AppStrings.authWelcomeBack: 'أهلاً بعودتك',
    AppStrings.authLogInSubtitle: 'سجّل الدخول لإدارة أدوية عائلتك اليومية',
    AppStrings.authForgotPasswordLink: 'نسيت كلمة المرور؟',
    AppStrings.authNoAccount: 'ليس لديك حساب؟',
    AppStrings.authInvalidCredentials:
        'البريد الإلكتروني أو كلمة المرور غير صحيحة',

    // ---- Auth: Sign Up ----
    AppStrings.authCreateAccountTitle: 'أنشئ حسابك',
    AppStrings.authCreateAccountSubtitle:
        'حساب محلي لمقدّم الرعاية لإدارة جرعات العائلة',
    AppStrings.authFullNameLabel: 'الاسم الكامل',
    AppStrings.authFullNameHint: 'أحمد محمد',
    AppStrings.authConfirmPasswordLabel: 'تأكيد كلمة المرور',
    AppStrings.authSecurityQuestionLabel: 'سؤال الأمان',
    AppStrings.authSecurityAnswerLabel: 'إجابتك',
    AppStrings.authSecurityAnswerHelper:
        'تُستخدم لإعادة تعيين كلمة المرور إذا نسيتها. لا تفرّق بين الأحرف '
        'الكبيرة والصغيرة.',
    AppStrings.authCreateAccountButton: 'إنشاء الحساب',
    AppStrings.authHaveAccount: 'لديك حساب بالفعل؟',

    // ---- Auth: Forgot Password ----
    AppStrings.forgotPasswordTitle: 'إعادة تعيين كلمة المرور',
    AppStrings.forgotPasswordEmailSubtitle:
        'أدخل البريد الإلكتروني لحسابك المحلي على هذا الجهاز.',
    AppStrings.forgotPasswordContinue: 'متابعة',
    AppStrings.forgotPasswordStepIndicator: 'الخطوة @current من @total',
    AppStrings.forgotPasswordStepVerify: 'التحقق من الحساب',
    AppStrings.forgotPasswordStepNewPassword: 'كلمة مرور جديدة',
    AppStrings.forgotPasswordNewTitle: 'تعيين كلمة مرور جديدة',
    AppStrings.forgotPasswordNewSubtitle:
        'أجب عن سؤال الأمان، ثم اختر كلمة مرور جديدة.',
    AppStrings.forgotPasswordNewPasswordLabel: 'كلمة المرور الجديدة',
    AppStrings.forgotPasswordResetButton: 'إعادة تعيين كلمة المرور',
    AppStrings.forgotPasswordAccountNotFound:
        'لا يوجد حساب على هذا الجهاز بهذا البريد الإلكتروني',
    AppStrings.forgotPasswordWrongAnswer: 'الإجابة غير صحيحة',
    AppStrings.forgotPasswordSuccess:
        'تم تحديث كلمة المرور. يمكنك تسجيل الدخول الآن.',
    AppStrings.forgotPasswordRemembered: 'تذكرت كلمة المرور؟',

    // ---- Security questions ----
    AppStrings.securityQuestionFirstSchool: 'ما اسم أول مدرسة التحقت بها؟',
    AppStrings.securityQuestionBirthCity: 'في أي مدينة وُلدت؟',
    AppStrings.securityQuestionFirstPet: 'ما اسم أول حيوان أليف امتلكته؟',
    AppStrings.securityQuestionFavoriteTeacher: 'من هو معلمك المفضل؟',
    AppStrings.securityQuestionChildhoodNickname: 'ما لقبك في الطفولة؟',

    // ---- Onboarding ----
    AppStrings.onboardingFamilyTitle: 'أدِر أدوية عائلتك كلها في مكان واحد',
    AppStrings.onboardingFamilyBody:
        'نظّم وتابع الجداول والجرعات والالتزام اليومي لكل أفراد العائلة '
        'تحت سقف واحد بسيط.',
    AppStrings.onboardingRemindersTitle: 'لا تفوّت أي جرعة',
    AppStrings.onboardingRemindersBody:
        'احصل على تذكيرات متصاعدة عند موعد الجرعة، ومتابعات إضافية إذا لم '
        'تُسجَّل كمأخوذة، وشاهد التزام عائلتك الشهري بنظرة واحدة.',
    AppStrings.onboardingStockTitle: 'تابع المخزون وشارك تقارير جاهزة للطبيب',
    AppStrings.onboardingStockBody:
        'احصل على تنبيهات إعادة التعبئة قبل نفاد الدواء، وأنشئ تقرير PDF '
        'مرتّباً لأي فرد من العائلة ليأخذه إلى طبيبه.',
    AppStrings.onboardingHaveAccount: 'لديك حساب بالفعل؟',
    AppStrings.onboardingPageIndicator: 'الصفحة @current من @total',

    // ---- Navigation (bottom bar tabs) ----
    AppStrings.navHome: 'الرئيسية',
    AppStrings.navSchedule: 'الجدول',
    AppStrings.navInventory: 'المخزون',
    AppStrings.navSettings: 'الإعدادات',

    // ---- Home (empty state) and shell ----
    AppStrings.homeEmptyTitle: 'أضف أول فرد من العائلة',
    AppStrings.homeEmptyMessage:
        'أنشئ ملفاً لنفسك أو لمن ترعاه، ثم أضف أدويته.',
    AppStrings.homeAddProfile: 'إضافة فرد من العائلة',
    AppStrings.a11yAddMedication: 'إضافة دواء',

    // ---- Settings ----
    AppStrings.settingsLanguage: 'اللغة',
    AppStrings.settingsAppearance: 'المظهر',
    AppStrings.settingsComingSoon: 'قريباً',
    AppStrings.settingsLogOut: 'تسجيل الخروج',
    AppStrings.languageEnglishName: 'English',
    AppStrings.languageArabicName: 'العربية',
  };
}
