import 'package:dose_tracker/features/auth/controllers/sign_up_controller.dart';
import 'package:dose_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:get/get.dart';

/// Provides the [SignUpController] when the Sign Up route opens and removes
/// it when the route closes.
///
/// It needs [AuthRepository], which is registered app-wide in
/// `InitialBinding` in a coming step, before any auth route is added.
class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(
      () => SignUpController(Get.find<AuthRepository>()),
    );
  }
}
