import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// Bottom-pinned action area for form screens (design `.sticky-cta`): the
/// [child] button sits over a fade into the page background so it stays
/// reachable while the form scrolls. Use it in `ScreenScaffold.overlays`
/// and give the scroll view [clearance] bottom padding.
class StickyCta extends StatelessWidget {
  const StickyCta({required this.child, super.key});

  final Widget child;

  /// Bottom padding a scroll view needs so its last item clears the button.
  static const double clearance = AppSizes.buttonHeight + 56;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.contentMaxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const <double>[0.7, 1],
            colors: <Color>[colors.appBackground, colors.appBackgroundClear],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSizes.screenPaddingHorizontal,
            AppSizes.spaceLg,
            AppSizes.screenPaddingHorizontal,
            AppSizes.spaceLg + bottomInset,
          ),
          child: child,
        ),
      ),
    );
  }
}
