import 'dart:ui' show ImageFilter;

import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Blurred sticky background shared by the headers. The hairline under it
/// fades in with [borderOpacity] once content scrolls beneath.
class AppHeaderSurface extends StatelessWidget {
  const AppHeaderSurface({
    required this.child,
    required this.borderOpacity,
    super.key,
  });

  final Widget child;
  final double borderOpacity;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppSizes.headerBlurSigma,
          sigmaY: AppSizes.headerBlurSigma,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.headerGlass,
            border: Border(
              bottom: BorderSide(
                color: colors.borderHairline.withValues(alpha: borderOpacity),
                width: AppSizes.borderHairline,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
