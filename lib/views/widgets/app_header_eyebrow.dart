import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';

/// Small pill above a large title, for example today's date.
class AppHeaderEyebrow extends StatelessWidget {
  const AppHeaderEyebrow({required this.label, this.icon, super.key});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return Container(
      height: AppSizes.headerEyebrowHeight,
      padding: const EdgeInsetsDirectional.only(
        start: AppSizes.headerEyebrowPaddingStart,
        end: AppSizes.headerEyebrowPaddingEnd,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        boxShadow: AppShadows.soft(colors),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: AppSizes.iconSm, color: colors.active),
            const SizedBox(width: AppSizes.headerEyebrowIconGap),
          ],
          Text(label, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
