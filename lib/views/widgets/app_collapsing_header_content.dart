import 'dart:ui' show lerpDouble;

import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/views/widgets/app_header_eyebrow.dart';
import 'package:dose_tracker/views/widgets/app_header_surface.dart';
import 'package:flutter/material.dart';

/// What `AppCollapsingHeader` paints at a given [progress], where 0 is fully
/// expanded and 1 fully collapsed.
class AppCollapsingHeaderContent extends StatelessWidget {
  const AppCollapsingHeaderContent({
    required this.progress,
    required this.title,
    this.eyebrowLabel,
    this.eyebrowIcon,
    this.trailing,
    super.key,
  });

  final double progress;
  final String title;
  final String? eyebrowLabel;
  final IconData? eyebrowIcon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final double bottomGap = lerpDouble(
      AppSizes.headerBottomExpanded,
      AppSizes.headerBottomCollapsed,
      progress,
    )!;
    final TextStyle titleStyle = Theme.of(context).textTheme.displayLarge!
        .copyWith(
          fontSize: lerpDouble(
            AppSizes.fontHero,
            AppSizes.fontHeroCollapsed,
            progress,
          ),
        );

    return AppHeaderSurface(
      borderOpacity: progress,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.contentMaxWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPaddingHorizontal,
            ),
            child: Stack(
              children: <Widget>[
                if (eyebrowLabel != null)
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    bottom:
                        bottomGap +
                        AppSizes.iconButtonSize +
                        AppSizes.headerEyebrowGap,
                    child: Opacity(
                      opacity: (1 - progress * 2).clamp(0, 1),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: AppHeaderEyebrow(
                          label: eyebrowLabel!,
                          icon: eyebrowIcon,
                        ),
                      ),
                    ),
                  ),
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: bottomGap,
                  height: AppSizes.iconButtonSize,
                  child: Row(
                    spacing: AppSizes.headerRowGap,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleStyle,
                        ),
                      ),
                      ?trailing,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
