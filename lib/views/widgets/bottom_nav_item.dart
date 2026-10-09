import 'package:flutter/widgets.dart';

/// Describes one tab of the bottom navigation bar.
///
/// [labelKey] is an `AppStrings` key. The bar translates it with `.tr`, so
/// the label follows the language without rebuilding the item list.
@immutable
class BottomNavItem {
  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.labelKey,
  });

  final IconData icon;
  final IconData activeIcon;
  final String labelKey;
}
