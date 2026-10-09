import 'package:get/get.dart';

/// Holds the selected bottom tab of the main shell.
///
/// Tab order is fixed: 0 Home, 1 Schedule, 2 Inventory, 3 Settings. The
/// shell keeps every tab alive in an `IndexedStack`, so switching tabs only
/// changes this index and never reloads a screen.
class MainShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void selectTab(int index) {
    if (index == currentIndex.value) {
      return;
    }
    currentIndex.value = index;
  }
}
