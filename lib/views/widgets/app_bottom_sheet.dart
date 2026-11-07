import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Modal bottom sheet frame: grabber, optional title and subtitle, then your
/// [child].
///
/// Open it with `AppBottomSheet.show(child: ...)`. [title] and [subtitle]
/// must already be translated; leave them out when [child] lays out its own
/// heading. The sheet scrolls, stays under 85% of the screen and rises above
/// the keyboard, and colors, radius and scrim come from the theme tokens.
class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    required this.child,
    this.title,
    this.subtitle,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final Widget child;

  static Future<T?> show<T>({
    required Widget child,
    String? title,
    String? subtitle,
  }) {
    final AppColorTokens colors = Get.theme.extension<AppColorTokens>()!;

    return Get.bottomSheet<T>(
      AppBottomSheet(title: title, subtitle: subtitle, child: child),
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
    final TextTheme textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight:
            MediaQuery.sizeOf(context).height * AppSizes.sheetMaxHeightFactor,
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSizes.screenPaddingHorizontal,
            right: AppSizes.screenPaddingHorizontal,
            top: AppSizes.sheetTopPadding,
            bottom:
                AppSizes.sheetBottomPadding +
                MediaQuery.viewInsetsOf(context).bottom,
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
                      color: colors.sheetHandle,
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sheetHandleGap),
                if (title != null) ...<Widget>[
                  Text(title!, style: textTheme.headlineMedium),
                  const SizedBox(height: AppSizes.spaceXs),
                ],
                if (subtitle != null)
                  Text(subtitle!, style: textTheme.bodyMedium),
                if (title != null || subtitle != null)
                  const SizedBox(height: AppSizes.sheetHandleGap),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
