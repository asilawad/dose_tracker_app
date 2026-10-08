import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/views/widgets/outlined_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Centered error placeholder with a retry button.
///
/// [message] must already be translated; it defaults to the generic error
/// text. The retry button label is the shared "Try again" translation.
class ErrorState extends StatelessWidget {
  const ErrorState({required this.onRetry, this.message, super.key});

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.space2xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: AppSizes.avatarXl,
              height: AppSizes.avatarXl,
              decoration: BoxDecoration(
                color: colors.dangerTint,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: AppSizes.iconXl,
                color: colors.danger,
              ),
            ),
            const SizedBox(height: AppSizes.space2xl),
            Text(
              message ?? AppStrings.stateErrorGeneric.tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSizes.space2xl),
            OutlinedActionButton(
              label: AppStrings.actionRetry.tr,
              icon: Icons.refresh_rounded,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
