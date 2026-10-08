import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

/// Builds the app [ThemeData] once from the semantic color tokens.
///
/// Dark mode later = a second factory that passes dark tokens; widgets are
/// untouched because they only read `context.appColors` and the text theme.
abstract final class AppTheme {
  static ThemeData light() => _build(AppColorTokens.light, Brightness.light);

  static ThemeData _build(AppColorTokens colors, Brightness brightness) {
    final TextTheme textTheme = AppTextTheme.build(colors);
    final ColorScheme scheme = ColorScheme(
      brightness: brightness,
      primary: colors.active,
      onPrimary: colors.onActive,
      secondary: colors.active,
      onSecondary: colors.onActive,
      error: colors.danger,
      onError: colors.onActive,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      outline: colors.borderHairline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.appBackground,
      canvasColor: colors.appBackground,
      textTheme: textTheme,
      dividerColor: colors.borderHairline,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.active,
        selectionColor: colors.activeTint,
        selectionHandleColor: colors.active,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        modalBackgroundColor: colors.surface,
        modalBarrierColor: colors.scrim,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusSheet),
          ),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[colors],
    );
  }
}
