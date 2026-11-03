import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/painting.dart';

/// The design's elevation recipes, built from the semantic color tokens.
abstract final class AppShadows {
  /// Hairline plus soft ambient shadow, used by cards and icon buttons.
  static List<BoxShadow> soft(AppColorTokens colors) {
    return <BoxShadow>[
      BoxShadow(
        color: colors.shadowHairline,
        blurRadius: AppSizes.shadowBlurHairline,
        offset: const Offset(0, AppSizes.shadowOffsetYHairline),
      ),
      BoxShadow(
        color: colors.shadowSoft,
        blurRadius: AppSizes.shadowBlurSoft,
        offset: const Offset(0, AppSizes.shadowOffsetYSoft),
      ),
    ];
  }

  /// Violet glow under gradient actions.
  static List<BoxShadow> active(AppColorTokens colors) {
    return <BoxShadow>[
      BoxShadow(
        color: colors.shadowActive,
        blurRadius: AppSizes.shadowBlurActive,
        offset: const Offset(0, AppSizes.shadowOffsetYActive),
      ),
    ];
  }
}
