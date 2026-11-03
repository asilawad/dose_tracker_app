import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// A tab's icon. When [selected] it waits for the circle to arrive, then
/// rises into it and turns white and filled; otherwise it drops back.
class NavBarTabIcon extends StatelessWidget {
  const NavBarTabIcon({
    required this.icon,
    required this.activeIcon,
    required this.selected,
    super.key,
  });

  final IconData icon;
  final IconData activeIcon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    final Duration motion = selected
        ? AppDurations.navIconRise
        : AppDurations.navIconDrop;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: selected ? 1 : 0),
      duration: reduceMotion ? Duration.zero : motion,
      curve: selected
          ? AppDurations.navIconRiseCurve
          : AppDurations.standardCurve,
      builder: (BuildContext context, double rise, Widget? child) {
        final double blend = rise.clamp(0, 1);

        return Transform.translate(
          offset: Offset(0, -AppSizes.navIconRise * rise),
          child: Icon(
            blend >= 0.5 ? activeIcon : icon,
            size: AppSizes.iconLg,
            color: Color.lerp(colors.textTertiary, colors.onActive, blend),
          ),
        );
      },
    );
  }
}
