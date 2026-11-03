import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/bottom_nav_item.dart';
import 'package:dose_tracker/views/widgets/nav_bar_tab_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// One tab of `AppBottomNavBar`: icon above label, the whole slot tappable.
class NavBarTabButton extends StatelessWidget {
  const NavBarTabButton({
    required this.item,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final BottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextStyle labelStyle = Theme.of(context).textTheme.labelSmall!;
    final String label = item.labelKey.tr;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: AppSizes.navLabelBottomPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: AppSizes.navIconLabelGap,
              children: <Widget>[
                NavBarTabIcon(
                  icon: item.icon,
                  activeIcon: item.activeIcon,
                  selected: selected,
                ),
                AnimatedDefaultTextStyle(
                  duration: AppDurations.tabSwitch,
                  style: labelStyle.copyWith(
                    color: selected ? colors.activeDeep : colors.textTertiary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
