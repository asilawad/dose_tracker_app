import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/validators.dart';
import 'package:dose_tracker/features/auth/controllers/forgot_password_controller.dart';
import 'package:dose_tracker/features/auth/data/models/security_question.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/auth_error_banner.dart';
import 'package:dose_tracker/views/widgets/app_card.dart';
import 'package:dose_tracker/views/widgets/app_text_field.dart';
import 'package:dose_tracker/views/widgets/app_text_link.dart';
import 'package:dose_tracker/views/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Step 2 of Forgot Password: shows the account's security question, then
/// takes the answer, the new password and its confirmation.
///
/// State comes from [ForgotPasswordController]. [onSubmit] is called by the
/// button and by "done" on the last field; the screen decides what happens
/// after a successful reset. A "Back" link returns to step 1.
class ForgotPasswordResetStep extends GetView<ForgotPasswordController> {
  const ForgotPasswordResetStep({required this.onSubmit, super.key});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Form(
      key: controller.resetFormKey,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              AppStrings.forgotPasswordNewTitle.tr,
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.spaceSm),
            Text(
              AppStrings.forgotPasswordNewSubtitle.tr,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSizes.space2xl),
            Obx(() => _QuestionBox(question: controller.question.value)),
            const SizedBox(height: AppSizes.spaceLg),
            AppTextField(
              label: AppStrings.authSecurityAnswerLabel.tr,
              controller: controller.answerController,
              prefixIcon: Icons.help_outline_rounded,
              textInputAction: TextInputAction.next,
              validator: Validators.required,
            ),
            const SizedBox(height: AppSizes.spaceLg),
            AppTextField(
              label: AppStrings.forgotPasswordNewPasswordLabel.tr,
              controller: controller.newPasswordController,
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
              textInputAction: TextInputAction.done,
              validator: controller.validateConfirmPassword,
              onSubmitted: (_) => onSubmit(),
            ),
            const SizedBox(height: AppSizes.space2xl),
            Obx(() => AuthErrorBanner(errorKey: controller.errorKey.value)),
            Obx(
              () => GradientButton(
                label: AppStrings.forgotPasswordResetButton.tr,
                icon: Icons.check_rounded,
                isLoading: controller.isLoading.value,
                onPressed: onSubmit,
              ),
            ),
            const SizedBox(height: AppSizes.spaceSm),
            Center(
              child: AppTextLink(
                label: AppStrings.actionBack.tr,
                onPressed: controller.backToEmailStep,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tinted box showing the account's security question, in the app language.
class _QuestionBox extends StatelessWidget {
  const _QuestionBox({required this.question});

  final SecurityQuestion? question;

  @override
  Widget build(BuildContext context) {
    final SecurityQuestion? current = question;
    if (current == null) {
      return const SizedBox.shrink();
    }
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.activeTint,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppStrings.authSecurityQuestionLabel.tr,
              style: textTheme.labelMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.spaceXs),
            Text(current.key.tr, style: textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
