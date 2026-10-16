import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/home/presentation/views/home_tab_view.dart';
import 'package:dose_tracker/features/inventory/presentation/views/inventory_tab_view.dart';
import 'package:dose_tracker/features/schedule/presentation/views/schedule_tab_view.dart';
import 'package:dose_tracker/features/settings/presentation/views/settings_tab_view.dart';
import 'package:dose_tracker/features/shell/controllers/main_shell_controller.dart';
import 'package:dose_tracker/views/widgets/app_bottom_nav_bar.dart';
import 'package:dose_tracker/views/widgets/bottom_nav_item.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The main screen after login: every tab lives in an `IndexedStack`, so
/// each keeps its state while the bottom bar switches between them.
///
/// The list below is the single source for both the bar and the pages, so
/// they can never get out of sync. The tabs are Home, Schedule, Inventory
/// and Settings, in that order. Medications are added from a profile's
/// page, so the shell has no add button. The controller comes from
/// `MainShellBinding`.
class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      padding: EdgeInsets.zero,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: <Widget>[for (final _ShellTab tab in _tabs) tab.page],
        ),
      ),
      bottomNavigationBar: Obx(
        () => AppBottomNavBar(
          items: <BottomNavItem>[for (final _ShellTab tab in _tabs) tab.item],
          currentIndex: controller.currentIndex.value,
          onTap: controller.selectTab,
        ),
      ),
    );
  }
}

class _ShellTab {
  const _ShellTab({required this.item, required this.page});

  final BottomNavItem item;
  final Widget page;
}

const List<_ShellTab> _tabs = <_ShellTab>[
  _ShellTab(
    item: BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      labelKey: AppStrings.navHome,
    ),
    page: HomeTabView(),
  ),
  _ShellTab(
    item: BottomNavItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today_rounded,
      labelKey: AppStrings.navSchedule,
    ),
    page: ScheduleTabView(),
  ),
  _ShellTab(
    item: BottomNavItem(
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2_rounded,
      labelKey: AppStrings.navInventory,
    ),
    page: InventoryTabView(),
  ),
  _ShellTab(
    item: BottomNavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      labelKey: AppStrings.navSettings,
    ),
    page: SettingsTabView(),
  ),
];
