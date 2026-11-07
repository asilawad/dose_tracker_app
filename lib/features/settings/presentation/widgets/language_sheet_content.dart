import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/translations/app_translations.dart';
import 'package:dose_tracker/features/settings/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The list inside the language bottom sheet: one radio row per supported
/// language, split by hairlines, with the one in use filled.
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
          for (final (int index, Locale locale)
              in AppTranslations.supportedLocales.indexed)
            _LanguageOption(
              showDivider: index > 0,
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
    required this.showDivider,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextStyle style = Theme.of(context).textTheme.bodyLarge!;

    return Semantics(
      button: true,
      inMutuallyExclusiveGroup: true,
      checked: selected,
      label: label,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: showDivider
                ? Border(
                    top: BorderSide(
                      color: colors.borderHairline,
                      width: AppSizes.borderHairline,
                    ),
                  )
                : null,
          ),
          child: InkWell(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppSizes.minTapTarget,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.radioRowPaddingHorizontal,
                  vertical: AppSizes.radioRowPaddingVertical,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text(label, style: style)),
                    const SizedBox(width: AppSizes.spaceMd),
                    _RadioMark(selected: selected),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The round radio mark: a ring, filled with a dot when [selected].
class _RadioMark extends StatelessWidget {
  const _RadioMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;

    return Container(
      width: AppSizes.radioSize,
      height: AppSizes.radioSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? colors.active : colors.radioIdle,
          width: AppSizes.radioBorder,
        ),
      ),
      child: selected
          ? Container(
              width: AppSizes.radioDotSize,
              height: AppSizes.radioDotSize,
              decoration: BoxDecoration(
                color: colors.active,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
