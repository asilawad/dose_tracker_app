import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/bottom_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Bottom navigation bar for the main shell.
///
/// Stateless: the selected tab lives in the shell controller, which passes
/// [currentIndex] and receives taps through [onTap]. The selected tab shows
/// its filled icon and the `active` color on a soft pill. The bar is capped
/// at `AppSizes.contentMaxWidth` and centered on wide screens, and each tab
/// is at least `AppSizes.minTapTarget` high and wide.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final List<BottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors.borderHairline,
            width: AppSizes.borderHairline,
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.shadowSoft,
            blurRadius: AppSizes.shadowBlurSoft,
            offset: const Offset(0, -AppSizes.shadowOffsetYSoft),
          ),
        ],
      ),
      child: Material(
        color: colors.surface,
        child: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.contentMaxWidth,
              ),
              child: SizedBox(
                height: AppSizes.bottomNavHeight,
                child: Row(
                  children: <Widget>[
                    for (int index = 0; index < items.length; index++)
                      Expanded(
                        child: _NavBarButton(
                          item: items[index],
                          selected: index == currentIndex,
                          onTap: () => onTap(index),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarButton extends StatelessWidget {
  const _NavBarButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final BottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextStyle labelStyle = Theme.of(context).textTheme.labelSmall!;
    final Color foreground = selected ? colors.active : colors.textSecondary;
    final String label = item.labelKey.tr;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: AppSizes.minTapTarget,
              minHeight: AppSizes.minTapTarget,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  duration: AppDurations.tabSwitch,
                  curve: AppDurations.standardCurve,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spaceLg,
                    vertical: AppSizes.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? colors.activeTint : null,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                  child: Icon(
                    selected ? item.activeIcon : item.icon,
                    size: AppSizes.iconLg,
                    color: foreground,
                  ),
                ),
                const SizedBox(height: AppSizes.spaceXs),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: labelStyle.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
