import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

/// Content of one onboarding slide. The texts are translation keys, shown
/// with `.tr` by the widget, so slides switch language with the app.
@immutable
class OnboardingSlide {
  const OnboardingSlide({
    required this.icon,
    required this.titleKey,
    required this.bodyKey,
  });

  final IconData icon;
  final String titleKey;
  final String bodyKey;
}

/// The three onboarding slides in display order: family management,
/// escalating reminders and adherence, then inventory and doctor reports.
abstract final class OnboardingSlides {
  static const List<OnboardingSlide> all = <OnboardingSlide>[
    OnboardingSlide(
      icon: Icons.family_restroom_rounded,
      titleKey: AppStrings.onboardingFamilyTitle,
      bodyKey: AppStrings.onboardingFamilyBody,
    ),
    OnboardingSlide(
      icon: Icons.notifications_active_rounded,
      titleKey: AppStrings.onboardingRemindersTitle,
      bodyKey: AppStrings.onboardingRemindersBody,
    ),
    OnboardingSlide(
      icon: Icons.inventory_2_rounded,
      titleKey: AppStrings.onboardingStockTitle,
      bodyKey: AppStrings.onboardingStockBody,
    ),
  ];
}
