import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// White rounded surface with a soft shadow, the base of every card.
///
/// Pass [onTap] to make the whole card tappable with an ink ripple. The
/// shadow lives on the outer [DecoratedBox] so the ripple never clips it.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSizes.spaceLg),
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusCard);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: radius,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.shadowSoft,
            blurRadius: AppSizes.shadowBlurSoft,
            offset: const Offset(0, AppSizes.shadowOffsetYSoft),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
