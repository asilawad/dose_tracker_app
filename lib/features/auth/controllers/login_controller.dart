import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/auth/data/models/auth_results.dart';
import 'package:dose_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// State and actions of the Log In screen: the two form fields, the loading
/// flag and the error message.
///
/// [submit] returns true when the login worked. Moving on to Home is added
/// in the Home step, because that route does not exist yet; until then the
/// screen simply stays put after a successful login. [errorKey] holds a
/// translation key, shown by the screen with `.tr`, so the message follows
/// the app language.
class LoginController extends GetxController {
  LoginController(this._auth);

  final AuthRepository _auth;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxnString errorKey = RxnString();

  Future<bool> submit() async {
    if (isLoading.value) {
      return false;
    }
    errorKey.value = null;
    if (!(formKey.currentState?.validate() ?? false)) {
      return false;
    }

    isLoading.value = true;
    try {
      final LogInResult result = await _auth.logIn(
        email: emailController.text,
        password: passwordController.text,
      );
      switch (result) {
        case LogInSuccess():
          return true;
        case LogInInvalidCredentials():
          errorKey.value = AppStrings.authInvalidCredentials;
          return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
