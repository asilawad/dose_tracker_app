import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/views/widgets/logo_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Splash animation: the logo scales and fades in, then the app name and
/// tagline fade in. One controller drives both phases through intervals, and
/// all timings come from [AppDurations].
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

  late final Animation<double> _logoScale = Tween<double>(begin: 0, end: 1)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0,
            _fraction(AppDurations.splashLogoEntrance),
            curve: AppDurations.entranceCurve,
          ),
        ),
      );

  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      0,
      _fraction(AppDurations.splashLogoEntrance),
      curve: AppDurations.standardCurve,
    ),
  );

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

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        FadeTransition(
          opacity: _logoFade,
          child: ScaleTransition(
            scale: _logoScale,
            child: const LogoImage(size: AppSizes.logoSplash),
          ),
        ),
        const SizedBox(height: AppSizes.spaceXl),
        FadeTransition(
          opacity: _textFade,
          child: Column(
            children: <Widget>[
              Text(AppStrings.appName.tr, style: textTheme.displayMedium),
              const SizedBox(height: AppSizes.spaceSm),
              Text(AppStrings.appTagline.tr, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
