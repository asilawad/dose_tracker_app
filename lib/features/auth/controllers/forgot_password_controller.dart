import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/auth/data/models/auth_results.dart';
import 'package:dose_tracker/features/auth/data/models/security_question.dart';
import 'package:dose_tracker/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// The two screens of the Forgot Password flow.
enum ForgotPasswordStep { email, reset }

/// State and actions of the two-step Forgot Password flow.
///
/// Step 1 takes the email and loads that account's security question. Step 2
/// asks the question and takes the new password with its confirmation.
/// [submitReset] returns true when the password was changed. Returning to
/// Log In is added in the Log In screen step, because that route does not
/// exist yet. [errorKey] holds a translation key, shown with `.tr`.
class ForgotPasswordController extends GetxController {
  ForgotPasswordController(this._auth);

  final AuthRepository _auth;

  final GlobalKey<FormState> emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final Rx<ForgotPasswordStep> step = ForgotPasswordStep.email.obs;
  final Rxn<SecurityQuestion> question = Rxn<SecurityQuestion>();
  final RxBool isLoading = false.obs;
  final RxnString errorKey = RxnString();

  int get stepCount => ForgotPasswordStep.values.length;

  /// One-based number of the current step, for the "Step 1 of 2" label.
  int get stepNumber => step.value.index + 1;

  /// Checks the confirmation against the new password field's current text.
  String? validateConfirmPassword(String? value) {
    return Validators.confirmPassword(value, newPasswordController.text);
  }

  /// Step 1: looks up the account and moves to step 2 when it exists.
  Future<void> submitEmail() async {
    if (isLoading.value) {
      return;
    }
    errorKey.value = null;
    if (!(emailFormKey.currentState?.validate() ?? false)) {
      return;
    }

    isLoading.value = true;
    try {
      final FindSecurityQuestionResult result = await _auth
          .findSecurityQuestion(emailController.text);
      switch (result) {
        case SecurityQuestionFound(:final SecurityQuestion question):
          this.question.value = question;
          step.value = ForgotPasswordStep.reset;
        case SecurityQuestionAccountNotFound():
          errorKey.value = AppStrings.forgotPasswordAccountNotFound;
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 2: checks the answer and saves the new password.
  Future<bool> submitReset() async {
    if (isLoading.value) {
      return false;
    }
    errorKey.value = null;
    if (!(resetFormKey.currentState?.validate() ?? false)) {
      return false;
    }

    isLoading.value = true;
    try {
      final ResetPasswordResult result = await _auth.resetPassword(
        email: emailController.text,
        answer: answerController.text,
        newPassword: newPasswordController.text,
      );
      switch (result) {
        case ResetPasswordSuccess():
          return true;
        case ResetPasswordWrongAnswer():
          errorKey.value = AppStrings.forgotPasswordWrongAnswer;
          return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Back from step 2 to step 1, clearing what was typed there so a changed
  /// email never reuses an old answer.
  void backToEmailStep() {
    answerController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    errorKey.value = null;
    step.value = ForgotPasswordStep.email;
  }

  @override
  void onClose() {
    emailController.dispose();
    answerController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
