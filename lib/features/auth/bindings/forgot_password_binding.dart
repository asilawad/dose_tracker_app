import 'package:dose_tracker/features/auth/controllers/forgot_password_controller.dart';
import 'package:dose_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

/// Provides the [ForgotPasswordController] when the Forgot Password route
/// opens and removes it when the route closes. One controller serves both
/// steps, so the typed email survives the move from step 1 to step 2.
///
/// It needs [AuthRepository], which is registered app-wide in
/// `InitialBinding` in a coming step, before any auth route is added.
class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(Get.find<AuthRepository>()),
    );
  }
}
