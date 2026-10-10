import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/home/presentation/views/home_tab_view.dart';
import 'package:dose_tracker/features/settings/presentation/views/settings_tab_view.dart';
import 'package:dose_tracker/features/shell/controllers/main_shell_controller.dart';
import 'package:dose_tracker/views/widgets/app_bottom_nav_bar.dart';
import 'package:dose_tracker/views/widgets/bottom_nav_item.dart';
import 'package:dose_tracker/views/widgets/gradient_fab.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The main screen after login: every tab lives in an `IndexedStack`, so
/// each keeps its state while the bottom bar switches between them.
///
/// The list below is the single source for both the bar and the pages, so
/// they can never get out of sync. Home and Settings exist so far; Schedule
/// and Inventory are added to the list in the steps that create them. The
/// add-medication button shows only on tabs marked `showsAddMedication`
/// (Home, Schedule and Inventory). The controller comes from
/// `MainShellBinding`.
class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      padding: EdgeInsets.zero,
      floatingActionButton: Obx(
        () => _tabs[controller.currentIndex.value].showsAddMedication
            ? GradientFab(
                onPressed: controller.openAddMedication,
                tooltip: AppStrings.a11yAddMedication.tr,
              )
            : const SizedBox.shrink(),
      ),
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
  const _ShellTab({
    required this.item,
    required this.page,
    this.showsAddMedication = false,
  });

  final BottomNavItem item;
  final Widget page;

  /// Whether the add-medication button is shown while this tab is open.
  final bool showsAddMedication;
}

const List<_ShellTab> _tabs = <_ShellTab>[
  _ShellTab(
    item: BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      labelKey: AppStrings.navHome,
    ),
    page: HomeTabView(),
    showsAddMedication: true,
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
