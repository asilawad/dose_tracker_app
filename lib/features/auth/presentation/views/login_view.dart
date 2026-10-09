import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/auth/controllers/login_controller.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/auth_header.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/auth_switch_prompt.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/login_form.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Log In screen: header, the form card, and the link to Sign Up.
///
/// A successful login opens Home (the controller does the navigation). The
/// links to Sign Up and Forgot Password open those screens. The controller
/// comes from `LoginBinding`.
class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: AppSizes.space2xl),
            AuthHeader(
              title: AppStrings.authWelcomeBack.tr,
              subtitle: AppStrings.authLogInSubtitle.tr,
            ),
            const SizedBox(height: AppSizes.space2xl),
            LoginForm(
              onSubmit: controller.submit,
              onForgotPassword: () =>
                  Get.toNamed<void>(AppRoutes.forgotPassword),
            ),
            const SizedBox(height: AppSizes.space2xl),
            AuthSwitchPrompt(
              prompt: AppStrings.authNoAccount.tr,
              linkLabel: AppStrings.authSignUp.tr,
              onPressed: () => Get.offNamed<void>(AppRoutes.signUp),
            ),
            const SizedBox(height: AppSizes.spaceLg),
          ],
        ),
      ),
    );
  }
}
