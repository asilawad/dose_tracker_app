import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/auth/controllers/sign_up_controller.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/security_question_picker.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The white Sign Up card: name, email, password, confirmation, security
/// question and answer, the error banner and the Create Account button.
///
/// Fields and state come from [SignUpController]. The password rules and the
/// confirmation check use the shared `Validators`. The answer only has to be
/// non-empty and is compared without caring about letter case. Pressing
/// "done" on the last field submits.
class SignUpForm extends GetView<SignUpController> {
  const SignUpForm({required this.onSubmit, super.key});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppTextField(
              label: AppStrings.authFullNameLabel.tr,
              hint: AppStrings.authFullNameHint.tr,
              controller: controller.nameController,
              prefixIcon: Icons.person_outline_rounded,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              validator: Validators.name,
            ),
            const SizedBox(height: AppSizes.spaceLg),
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
              textInputAction: TextInputAction.next,
              validator: Validators.password,
            ),
            const SizedBox(height: AppSizes.spaceLg),
            AppTextField(
              label: AppStrings.authConfirmPasswordLabel.tr,
              controller: controller.confirmPasswordController,
              prefixIcon: Icons.lock_reset_rounded,
              isPassword: true,
              textInputAction: TextInputAction.next,
              validator: controller.validateConfirmPassword,
            ),
            const SizedBox(height: AppSizes.spaceLg),
            SecurityQuestionPicker(
              initialQuestion: controller.selectedQuestion.value,
              onChanged: controller.selectQuestion,
            ),
            const SizedBox(height: AppSizes.spaceLg),
            AppTextField(
              label: AppStrings.authSecurityAnswerLabel.tr,
              controller: controller.answerController,
              prefixIcon: Icons.help_outline_rounded,
              textInputAction: TextInputAction.done,
              validator: Validators.required,
              onSubmitted: (_) => onSubmit(),
            ),
            const SizedBox(height: AppSizes.spaceSm),
            Text(
              AppStrings.authSecurityAnswerHelper.tr,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSizes.space2xl),
            Obx(() => AuthErrorBanner(errorKey: controller.errorKey.value)),
            Obx(
              () => GradientButton(
                label: AppStrings.authCreateAccountButton.tr,
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
