import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Modal bottom sheet frame: drag handle, title, then your [child].
///
/// Open it with `AppBottomSheet.show(title: ..., child: ...)`. [title] must
/// already be translated. The sheet scrolls and rises above the keyboard,
/// and colors, radius and scrim come from the theme tokens.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  static Future<T?> show<T>({required String title, required Widget child}) {
    final AppColorTokens colors = Get.theme.extension<AppColorTokens>()!;

    return Get.bottomSheet<T>(
      AppBottomSheet(title: title, child: child),
      isScrollControlled: true,
      backgroundColor: colors.surface,
      barrierColor: colors.scrim,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusSheet),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSizes.screenPaddingHorizontal,
          right: AppSizes.screenPaddingHorizontal,
          top: AppSizes.spaceMd,
          bottom: AppSizes.spaceLg + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: AppSizes.sheetHandleWidth,
                  height: AppSizes.sheetHandleHeight,
                  decoration: BoxDecoration(
                    color: colors.borderHairline,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.spaceLg),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSizes.spaceLg),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
