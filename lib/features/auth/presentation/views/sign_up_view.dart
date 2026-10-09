import 'package:dose_tracker/app/routes/app_routes.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/features/auth/controllers/sign_up_controller.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/auth_header.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/auth_switch_prompt.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Sign Up screen: header, the form card, and the link to Log In.
///
/// It has no back arrow, as an entry screen. A successful sign-up opens
/// Home (the controller does the navigation). The link to Log In replaces
/// this screen
/// (`offNamed`) so the two screens never pile up. The controller comes from
/// `SignUpBinding`.
class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: AppSizes.space2xl),
            AuthHeader(
              title: AppStrings.authCreateAccountTitle.tr,
              subtitle: AppStrings.authCreateAccountSubtitle.tr,
            ),
            const SizedBox(height: AppSizes.space2xl),
            SignUpForm(onSubmit: controller.submit),
            const SizedBox(height: AppSizes.space2xl),
            AuthSwitchPrompt(
              prompt: AppStrings.authHaveAccount.tr,
              linkLabel: AppStrings.authLogIn.tr,
              onPressed: () => Get.offNamed<void>(AppRoutes.logIn),
            ),
            const SizedBox(height: AppSizes.spaceLg),
          ],
        ),
      ),
    );
  }
}
