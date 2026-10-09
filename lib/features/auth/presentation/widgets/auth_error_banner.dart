import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Inline error box shown above a form's button, for example "Email or
/// password is incorrect".
///
/// [errorKey] is a translation key (the controllers keep keys, not text), so
/// the message follows the app language. When it is null nothing is drawn
/// and no space is taken. Screen readers announce it as soon as it appears.
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({required this.errorKey, super.key});

  final String? errorKey;

  @override
  Widget build(BuildContext context) {
    final String? key = errorKey;
    if (key == null) {
      return const SizedBox.shrink();
    }
    final AppColorTokens colors = context.appColors;

    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.spaceLg),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.dangerTint,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spaceMd),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.error_outline_rounded,
                  size: AppSizes.iconMd,
                  color: colors.danger,
                ),
                const SizedBox(width: AppSizes.spaceSm),
                Expanded(
                  child: Text(
                    key.tr,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
