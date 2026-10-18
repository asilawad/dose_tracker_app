import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/views/widgets/logo_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Splash content: the logo is shown at once, at the exact center of the
/// screen and at the same size as the native splash image, so the hand-off
/// from the native splash is invisible; then the app name and tagline fade
/// in below it.
class SplashContent extends StatefulWidget {
  const SplashContent({super.key});

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent>
    with SingleTickerProviderStateMixin {
  static final Duration _total =
      AppDurations.splashTextDelay + AppDurations.splashTextEntrance;

  static double _fraction(Duration part) =>
      part.inMilliseconds / _total.inMilliseconds;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _total,
  )..forward();

  late final Animation<double> _textFade = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      _fraction(AppDurations.splashTextDelay),
      1,
      curve: AppDurations.standardCurve,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    // The logo is the only child that takes part in the layout, so it stays
    // at the exact center; the text hangs below it without moving it.
    return SizedBox(
      width: AppSizes.logoSplash,
      height: AppSizes.logoSplash,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          const LogoImage(size: AppSizes.logoSplash),
          Positioned(
            top: AppSizes.logoSplash + AppSizes.spaceXl,
            left: -AppSizes.splashTextOverflow,
            right: -AppSizes.splashTextOverflow,
            child: FadeTransition(
              opacity: _textFade,
              child: Column(
                children: <Widget>[
                  Text(
                    AppStrings.appName.tr,
                    textAlign: TextAlign.center,
                    style: textTheme.displayMedium,
                  ),
                  const SizedBox(height: AppSizes.spaceSm),
                  Text(
                    AppStrings.appTagline.tr,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
