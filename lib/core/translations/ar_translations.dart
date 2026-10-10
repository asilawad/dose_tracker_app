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
    AppStrings.validationNameLong: 'يجب ألا يزيد الاسم عن @max حرفاً',
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

    // ---- Identity color names (accessibility labels) ----
    AppStrings.personaColorTeal: 'تركوازي',
    AppStrings.personaColorRose: 'وردي',
    AppStrings.personaColorOrange: 'برتقالي',
    AppStrings.personaColorPurple: 'بنفسجي',
    AppStrings.personaColorBlue: 'أزرق',

    // ---- Profiles: Add Profile ----
    AppStrings.profilesAddTitle: 'إضافة فرد من العائلة',
    AppStrings.profilesColorLabel: 'اختر لوناً لهذا الملف',
    AppStrings.profilesNameLabel: 'الاسم الكامل',
    AppStrings.profilesNameHint: 'مثال: ماما',

    // ---- Medications: Add Medication ----
    AppStrings.medsAddTitle: 'إضافة دواء جديد',
    AppStrings.medsRecipientLabel: 'متلقي الجرعة',
    AppStrings.medsRecipientChange: 'تغيير',
    AppStrings.medsRecipientSheetTitle: 'لمن هذا الدواء؟',
    AppStrings.medsNoProfiles: 'أضف فرداً من العائلة أولاً',
    AppStrings.medsNameLabel: 'اسم الدواء / المكمّل',
    AppStrings.medsNameHint: 'مثال: ميتفورمين',
    AppStrings.medsDoseLabel: 'مقدار الجرعة ووحدتها',
    AppStrings.medsDoseHint: '500',
    AppStrings.medsUnitMg: 'ملغ',
    AppStrings.medsUnitIu: 'و.د',
    AppStrings.medsUnitMl: 'مل',
    AppStrings.medsUnitPills: 'حبوب',
    AppStrings.medsFrequencyTitle: 'التكرار اليومي',
    AppStrings.medsFrequencySubtitle: 'يُوزَّع تلقائياً على اليوم',
    AppStrings.medsFrequencyUnit: 'مرات',
    AppStrings.medsScheduleTitle: 'جدول الجرعات',
    AppStrings.medsAddTime: 'إضافة موعد آخر',
    AppStrings.medsEditTimeTitle: 'تعديل موعد الجرعة',
    AppStrings.medsQuantityLabel: 'الكمية في كل جرعة',
    AppStrings.medsQuantitySummary: 'الكمية: @count',
    AppStrings.medsMealTitle: 'التعليمات مع الوجبات',
    AppStrings.medsMealBefore: 'قبل الأكل',
    AppStrings.medsMealWith: 'مع الأكل',
    AppStrings.medsMealAfter: 'بعد الأكل',
    AppStrings.medsInventoryTitle: 'تتبّع المخزون',
    AppStrings.medsInventorySubtitle: 'ينقص العدد عند تسجيل كل جرعة',
    AppStrings.medsStockLabel: 'المخزون الحالي',
    AppStrings.medsStockNote:
        'ستصلك تنبيهات إعادة التعبئة عند بقاء 10٪ من المخزون.',
    AppStrings.medsSave: 'حفظ جدول الدواء',
    AppStrings.medsSaved: 'تمت إضافة الدواء',
    AppStrings.medsErrorProfileNotFound: 'هذا الفرد لم يعد موجوداً.',
    AppStrings.medsErrorInvalidSchedule:
        'راجع مواعيد الجرعات: يجب أن يختلف كل موعد وأن تكون كل كمية أكبر '
        'من صفر.',
    AppStrings.medsErrorInvalidStock:
        'أدخل مخزوناً أكبر من صفر، أو أوقف التتبّع.',
    AppStrings.validationNumberInvalid: 'أدخل رقماً أكبر من صفر',
    AppStrings.a11yFrequencyIncrease: 'زيادة التكرار اليومي',
    AppStrings.a11yFrequencyDecrease: 'تقليل التكرار اليومي',
    AppStrings.a11yEditTime: 'تعديل موعد الجرعة',
    AppStrings.a11yRemoveTime: 'حذف موعد الجرعة',
  };
}
