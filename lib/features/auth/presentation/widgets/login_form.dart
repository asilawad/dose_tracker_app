import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/auth/controllers/login_controller.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:dose_tracker/views/widgets/app_text_link.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The white Log In card: email, password, the "Forgot Password?" link, the
/// error banner and the Log In button.
///
/// Fields and state come from [LoginController]. The password field only
/// checks "not empty", so a wrong login never reveals the password rules.
/// Pressing "done" on the keyboard submits, and the button shows a spinner
/// while the login runs.
class LoginForm extends GetView<LoginController> {
  const LoginForm({
    required this.onSubmit,
    required this.onForgotPassword,
    super.key,
  });

  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppTextField(
              label: AppStrings.authEmailLabel.tr,
              hint: AppStrings.authEmailHint.tr,
              controller: controller.emailController,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: Validators.email,
            ),
            const SizedBox(height: AppSizes.spaceLg),
            AppTextField(
              label: AppStrings.authPasswordLabel.tr,
              controller: controller.passwordController,
              prefixIcon: Icons.lock_outline_rounded,
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: Validators.required,
              onSubmitted: (_) => onSubmit(),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppTextLink(
                label: AppStrings.authForgotPasswordLink.tr,
                onPressed: onForgotPassword,
              ),
            ),
            const SizedBox(height: AppSizes.spaceSm),
            Obx(() => AuthErrorBanner(errorKey: controller.errorKey.value)),
            Obx(
              () => GradientButton(
                label: AppStrings.authLogIn.tr,
                icon: Icons.arrow_forward_rounded,
                isLoading: controller.isLoading.value,
                onPressed: onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
