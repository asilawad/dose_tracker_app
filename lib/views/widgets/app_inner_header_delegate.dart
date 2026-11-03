import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/views/widgets/app_inner_header_content.dart';
import 'package:flutter/material.dart';

/// Fixed-height sticky delegate behind `AppInnerHeader`.
class AppInnerHeaderDelegate extends SliverPersistentHeaderDelegate {
  const AppInnerHeaderDelegate({
    required this.title,
    required this.topInset,
    this.trailing,
  });

  final String title;
  final double topInset;
  final Widget? trailing;

  @override
  double get minExtent => maxExtent;

  @override
  double get maxExtent =>
      topInset +
      AppSizes.headerCollapsedTopGap +
      AppSizes.iconButtonSize +
      AppSizes.headerBottomCollapsed;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return AppInnerHeaderContent(
      title: title,
      scrolled: shrinkOffset > 0 || overlapsContent,
      trailing: trailing,
    );
  }

  @override
  bool shouldRebuild(AppInnerHeaderDelegate oldDelegate) {
    return oldDelegate.title != title ||
        oldDelegate.topInset != topInset ||
        oldDelegate.trailing != trailing;
  }
}
