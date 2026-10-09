import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/auth/controllers/forgot_password_controller.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Step 1 of Forgot Password: the card asking for the account email.
///
/// State and the action come from [ForgotPasswordController]. A wrong email
/// shows the "no account uses this email" banner. Pressing "done" on the
/// keyboard continues, and the button shows a spinner while it looks up the
/// account.
class ForgotPasswordEmailStep extends GetView<ForgotPasswordController> {
  const ForgotPasswordEmailStep({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Form(
      key: controller.emailFormKey,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              AppStrings.forgotPasswordTitle.tr,
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.spaceSm),
            Text(
              AppStrings.forgotPasswordEmailSubtitle.tr,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSizes.space2xl),
            AppTextField(
              label: AppStrings.authEmailLabel.tr,
              hint: AppStrings.authEmailHint.tr,
              controller: controller.emailController,
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: Validators.email,
              onSubmitted: (_) => controller.submitEmail(),
            ),
            const SizedBox(height: AppSizes.space2xl),
            Obx(() => AuthErrorBanner(errorKey: controller.errorKey.value)),
            Obx(
              () => GradientButton(
                label: AppStrings.forgotPasswordContinue.tr,
                icon: Icons.arrow_forward_rounded,
                isLoading: controller.isLoading.value,
                onPressed: controller.submitEmail,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
