import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/features/onboarding/bindings/onboarding_binding.dart';
import 'package:dose_tracker/features/onboarding/presentation/views/onboarding_view.dart';
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
  ];
}
