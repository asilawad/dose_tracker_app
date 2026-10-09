import 'package:dose_tracker/features/auth/controllers/login_controller.dart';
import 'package:dose_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

/// Provides the [LoginController] when the Log In route opens and removes it
/// when the route closes.
///
/// It needs [AuthRepository], which is registered app-wide in
/// `InitialBinding` in a coming step, before any auth route is added, so
/// nothing can reach this binding before the repository exists.
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(Get.find<AuthRepository>()),
    );
  }
}
