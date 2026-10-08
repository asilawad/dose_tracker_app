import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:flutter/widgets.dart';

/// Screen-size queries for the phone-first layout.
///
/// Phones use the full width. On wide screens (Windows, tablets) content is
/// capped at [AppSizes.contentMaxWidth] and centered, so the mobile design
/// is never stretched. Limits live in [AppSizes], not here.
abstract final class Responsive {
  static double width(BuildContext context) => MediaQuery.sizeOf(context).width;

  static bool isWide(BuildContext context) =>
      width(context) >= AppSizes.breakpointMedium;

  /// Width the page content should occupy.
  static double contentWidth(BuildContext context) {
    final double available = width(context);
    return available > AppSizes.contentMaxWidth
        ? AppSizes.contentMaxWidth
        : available;
  }
}
