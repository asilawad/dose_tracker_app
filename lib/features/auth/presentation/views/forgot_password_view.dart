import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/utils/app_snackbar.dart';
import 'package:dose_tracker/features/auth/controllers/forgot_password_controller.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/auth_switch_prompt.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/forgot_password_email_step.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/forgot_password_reset_step.dart';
import 'package:dose_tracker/features/auth/presentation/widgets/forgot_password_step_indicator.dart';
import 'package:dose_tracker/views/widgets/app_inner_header.dart';
import 'package:dose_tracker/views/widgets/screen_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The Forgot Password screen: step indicator, then step 1 (email) or step 2
/// (security answer and new password), and a link back to Log In.
///
/// It is opened from Log In, so the header's back button and the link both
/// return there. After a successful reset it shows a success
/// message and goes back to Log In. The controller comes from
/// `ForgotPasswordBinding`.
class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  Future<void> _submitReset() async {
    final bool isReset = await controller.submitReset();
    if (isReset) {
      AppSnackbar.success(AppStrings.forgotPasswordSuccess.tr);
      Get.back<void>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      padding: EdgeInsets.zero,
      body: CustomScrollView(
        slivers: <Widget>[
          AppInnerHeader(title: AppStrings.appName.tr),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.screenPaddingHorizontal,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: AppSizes.spaceSm),
                  Obx(
                    () => ForgotPasswordStepIndicator(
                      currentStep: controller.stepNumber,
                    ),
                  ),
                  const SizedBox(height: AppSizes.space2xl),
                  Obx(
                    () => controller.step.value == ForgotPasswordStep.email
                        ? const ForgotPasswordEmailStep()
                        : ForgotPasswordResetStep(onSubmit: _submitReset),
                  ),
                  const SizedBox(height: AppSizes.space2xl),
                  AuthSwitchPrompt(
                    prompt: AppStrings.forgotPasswordRemembered.tr,
                    linkLabel: AppStrings.authLogIn.tr,
                    onPressed: () => Get.back<void>(),
                  ),
                  const SizedBox(height: AppSizes.spaceLg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
