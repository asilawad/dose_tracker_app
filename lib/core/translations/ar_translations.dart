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
  };
}
