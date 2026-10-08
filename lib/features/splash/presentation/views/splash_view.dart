import 'package:dose_tracker/features/splash/presentation/widgets/splash_content.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';

/// First screen shown at launch: the animated logo and app name.
///
/// Auto-advance to onboarding or home is added in the step that creates
/// those screens, so this file never references a screen that does not exist.
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenScaffold(body: Center(child: SplashContent()));
  }
}
