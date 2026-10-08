import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum _SnackbarKind { success, error, info }

/// Single entry point for user feedback toasts.
///
/// Pass an already-translated message (`AppStrings.x.tr`). Colors come from
/// the theme tokens, so a dark theme restyles every snackbar automatically.
abstract final class AppSnackbar {
  static void success(String message) => _show(message, _SnackbarKind.success);

  static void error(String message) => _show(message, _SnackbarKind.error);

  static void info(String message) => _show(message, _SnackbarKind.info);

  static void _show(String message, _SnackbarKind kind) {
    final ThemeData theme = Get.theme;
    final AppColorTokens colors = theme.extension<AppColorTokens>()!;
    final Color background = switch (kind) {
      _SnackbarKind.success => colors.successTint,
      _SnackbarKind.error => colors.dangerTint,
      _SnackbarKind.info => colors.activeTint,
    };

    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      messageText: Text(message, style: theme.textTheme.bodyLarge),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: background,
      margin: const EdgeInsets.all(AppSizes.spaceLg),
      borderRadius: AppSizes.radiusMd,
      duration: AppDurations.snackbarVisible,
      animationDuration: AppDurations.normal,
    );
  }
}
