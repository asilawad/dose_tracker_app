import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/translations/app_translations.dart';
import 'package:dose_tracker/features/settings/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The list inside the language bottom sheet: one row per supported
/// language, with a check on the one in use.
///
/// Choosing a row switches the app language live (the whole UI mirrors for
/// Arabic) and closes the sheet. The controller comes from
/// `SettingsBinding`.
class LanguageSheetContent extends GetView<SettingsController> {
  const LanguageSheetContent({super.key});

  Future<void> _select(Locale locale) async {
    await controller.changeLanguage(locale);
    Get.back<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final String currentCode = controller.currentLocale.value.languageCode;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final Locale locale in AppTranslations.supportedLocales)
            _LanguageOption(
              label: controller.languageName(locale),
              selected: locale.languageCode == currentCode,
              onTap: () => _select(locale),
            ),
        ],
      );
    });
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextStyle style = Theme.of(context).textTheme.bodyLarge!;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: ExcludeSemantics(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    label,
                    style: style.copyWith(
                      color: selected ? colors.active : null,
                    ),
                  ),
                ),
                if (selected)
                  Icon(
                    Icons.check_rounded,
                    size: AppSizes.iconLg,
                    color: colors.active,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
