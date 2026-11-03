import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/views/widgets/app_collapsing_header_content.dart';
import 'package:flutter/material.dart';

/// Sizes the large header and reports how far it has collapsed.
class AppCollapsingHeaderDelegate extends SliverPersistentHeaderDelegate {
  const AppCollapsingHeaderDelegate({
    required this.title,
    required this.topInset,
    this.eyebrowLabel,
    this.eyebrowIcon,
    this.trailing,
  });

  final String title;
  final double topInset;
  final String? eyebrowLabel;
  final IconData? eyebrowIcon;
  final Widget? trailing;

  @override
  double get minExtent =>
      topInset +
      AppSizes.headerCollapsedTopGap +
      AppSizes.iconButtonSize +
      AppSizes.headerBottomCollapsed;

  @override
  double get maxExtent =>
      topInset +
      AppSizes.headerTopGap +
      (eyebrowLabel == null
          ? 0
          : AppSizes.headerEyebrowHeight + AppSizes.headerEyebrowGap) +
      AppSizes.iconButtonSize +
      AppSizes.headerBottomExpanded;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return AppCollapsingHeaderContent(
      progress: (shrinkOffset / (maxExtent - minExtent)).clamp(0, 1),
      title: title,
      eyebrowLabel: eyebrowLabel,
      eyebrowIcon: eyebrowIcon,
      trailing: trailing,
    );
  }

  @override
  bool shouldRebuild(AppCollapsingHeaderDelegate oldDelegate) {
    return oldDelegate.title != title ||
        oldDelegate.topInset != topInset ||
        oldDelegate.eyebrowLabel != eyebrowLabel ||
        oldDelegate.eyebrowIcon != eyebrowIcon ||
        oldDelegate.trailing != trailing;
  }
}
