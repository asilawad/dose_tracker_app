import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/bottom_nav_item.dart';
import 'package:dose_tracker/views/widgets/nav_bar_tab_button.dart';
import 'package:dose_tracker/views/widgets/nav_hop_indicator.dart';
import 'package:flutter/material.dart';

/// Floating white navigation bar with a gradient circle that hops to the
/// selected tab.
///
/// Stateless: the selected tab lives in the shell controller, which passes
/// [currentIndex] and receives taps through [onTap]. The bar is capped at
/// `AppSizes.contentMaxWidth` and centered on wide screens.
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

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.bottomNavMargin,
        right: AppSizes.bottomNavMargin,
        bottom:
            AppSizes.bottomNavBottomGap + MediaQuery.paddingOf(context).bottom,
      ),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.contentMaxWidth),
          child: SizedBox(
            height: AppSizes.bottomNavHeight + AppSizes.navIndicatorRise,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Positioned.fill(
                      top: AppSizes.navIndicatorRise,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusNavBar,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: colors.shadowNav,
                              blurRadius: AppSizes.bottomNavBlur,
                              offset: const Offset(
                                0,
                                AppSizes.bottomNavOffsetY,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    NavHopIndicator(
                      index: currentIndex,
                      slotWidth: constraints.maxWidth / items.length,
                    ),
                    Positioned.fill(
                      top: AppSizes.navIndicatorRise,
                      child: Row(
                        children: <Widget>[
                          for (int index = 0; index < items.length; index++)
                            Expanded(
                              child: NavBarTabButton(
                                item: items[index],
                                selected: index == currentIndex,
                                onTap: () => onTap(index),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
