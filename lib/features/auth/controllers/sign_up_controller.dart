import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/auth/data/models/auth_results.dart';
import 'package:dose_tracker/features/auth/data/models/security_question.dart';
import 'package:dose_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// State and actions of the Sign Up screen: the form fields, the chosen
/// security question, the loading flag and the error message.
///
/// [submit] returns true when the account was created and logged in, and
/// then replaces the whole navigation stack with Home. No profile is created
/// here: Home shows its empty state. [errorKey] holds a translation key,
/// shown by the screen with `.tr`.
class SignUpController extends GetxController {
  SignUpController(this._auth);

  final AuthRepository _auth;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController answerController = TextEditingController();

  /// The question offered first; the user can pick another from the list.
  final Rx<SecurityQuestion> selectedQuestion =
      SecurityQuestion.values.first.obs;

  final RxBool isLoading = false.obs;
  final RxnString errorKey = RxnString();

  void selectQuestion(SecurityQuestion question) {
    selectedQuestion.value = question;
  }

  /// Checks the confirmation against the password field's current text.
  String? validateConfirmPassword(String? value) {
    return Validators.confirmPassword(value, passwordController.text);
  }

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
      final SignUpResult result = await _auth.signUp(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        question: selectedQuestion.value,
        answer: answerController.text,
      );
      switch (result) {
        case SignUpSuccess():
          Get.offAllNamed<void>(AppRoutes.home);
          return true;
        case SignUpEmailTaken():
          errorKey.value = AppStrings.authEmailTaken;
          return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    answerController.dispose();
    super.onClose();
  }
}
