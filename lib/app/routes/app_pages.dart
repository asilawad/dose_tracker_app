import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/features/auth/bindings/forgot_password_binding.dart';
import 'package:dose_tracker/features/auth/bindings/login_binding.dart';
import 'package:dose_tracker/features/auth/bindings/sign_up_binding.dart';
import 'package:dose_tracker/features/auth/presentation/views/forgot_password_view.dart';
import 'package:dose_tracker/features/auth/presentation/views/login_view.dart';
import 'package:dose_tracker/features/auth/presentation/views/sign_up_view.dart';
import 'package:dose_tracker/features/medications/bindings/add_medication_binding.dart';
import 'package:dose_tracker/features/medications/bindings/edit_medication_binding.dart';
import 'package:dose_tracker/features/medications/presentation/views/medication_form_view.dart';
import 'package:dose_tracker/features/onboarding/bindings/onboarding_binding.dart';
import 'package:dose_tracker/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:dose_tracker/features/profile_detail/bindings/profile_detail_binding.dart';
import 'package:dose_tracker/features/profile_detail/bindings/profile_medications_binding.dart';
import 'package:dose_tracker/features/profile_detail/presentation/views/profile_detail_view.dart';
import 'package:dose_tracker/features/profile_detail/presentation/views/profile_medications_view.dart';
import 'package:dose_tracker/features/profiles/bindings/add_profile_binding.dart';
import 'package:dose_tracker/features/profiles/bindings/edit_profile_binding.dart';
import 'package:dose_tracker/features/profiles/presentation/views/add_profile_view.dart';
import 'package:dose_tracker/features/profiles/presentation/views/edit_profile_view.dart';
import 'package:dose_tracker/features/reports/bindings/report_binding.dart';
import 'package:dose_tracker/features/reports/presentation/views/report_view.dart';
import 'package:dose_tracker/features/shell/bindings/main_shell_binding.dart';
import 'package:dose_tracker/features/shell/presentation/views/main_shell_view.dart';
import 'package:dose_tracker/features/splash/bindings/splash_binding.dart';
import 'package:dose_tracker/features/splash/presentation/views/splash_view.dart';
import 'package:get/get.dart';

/// The route table. A route is added here only in the step that creates its
/// screen, so every entry points to a file that exists.
abstract final class AppPages {
  static const String initial = AppRoutes.splash;

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.logIn,
      page: () => const LoginView(),
      binding: LoginBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.signUp,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: () => const MainShellView(),
      binding: MainShellBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.addProfile,
      page: () => const AddProfileView(),
      binding: AddProfileBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.addMedication,
      page: () => const MedicationFormView(),
      binding: AddMedicationBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.editMedication,
      page: () => const MedicationFormView(),
      binding: EditMedicationBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.profile,
      page: () => const ProfileDetailView(),
      binding: ProfileDetailBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.profileMedications,
      page: () => const ProfileMedicationsView(),
      binding: ProfileMedicationsBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
    GetPage<dynamic>(
      name: AppRoutes.report,
      page: () => const ReportView(),
      binding: ReportBinding(),
      transitionDuration: AppDurations.pageTransition,
    ),
  ];
}
