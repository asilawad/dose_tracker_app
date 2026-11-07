import 'package:get/get.dart';

/// Holds the selected bottom tab of the main shell.
///
/// Tab order is fixed: 0 Home, 1 Schedule, 2 Inventory, 3 Settings. The
/// shell keeps every tab alive in an `IndexedStack`, so switching tabs only
/// changes this index and never reloads a screen.
class MainShellController extends GetxController {
  static const int homeTab = 0;
  static const int scheduleTab = 1;
  static const int inventoryTab = 2;
  static const int settingsTab = 3;

  final RxInt currentIndex = homeTab.obs;

  void selectTab(int index) {
    if (index == currentIndex.value) {
      return;
    }
    currentIndex.value = index;
  }
}
