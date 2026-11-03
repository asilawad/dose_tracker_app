import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Soft fade behind the floating bar, so scrolling content dissolves into
/// the background instead of looking cut. It never takes touches.
class NavBarFade extends StatelessWidget {
  const NavBarFade({super.key});

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return IgnorePointer(
      child: SizedBox(
        width: double.infinity,
        height:
            AppSizes.bottomNavFadeHeight + MediaQuery.paddingOf(context).bottom,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[
                colors.appBackground,
                colors.appBackground,
                colors.appBackgroundClear,
              ],
              stops: const <double>[0, 0.5, 1],
            ),
          ),
        ),
      ),
    );
  }
}
