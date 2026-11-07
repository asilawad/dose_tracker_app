import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/theme/persona_palette.dart';
import 'package:dose_tracker/views/widgets/persona_avatar.dart';
import 'package:flutter/material.dart';

/// Rounded square medication icon from the redesign (`.pill-tile`), tinted
/// with the persona color. [badge] adds the small profile avatar at the
/// bottom end corner (design `.who`).
class PillTile extends StatelessWidget {
  const PillTile({
    required this.persona,
    this.icon = Icons.medication_rounded,
    this.badge,
    this.background,
    this.foreground,
    this.size = AppSizes.pillTileSize,
    super.key,
  });

  final PersonaColor persona;
  final IconData icon;
  final PersonaAvatar? badge;

  /// Overrides the persona tint, for example a danger tile.
  final Color? background;
  final Color? foreground;
  final double size;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final PersonaShade shade = persona.resolve(colors);

    final Widget tile = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background ?? shade.tint,
        borderRadius: BorderRadius.circular(
          size * AppSizes.pillTileRadius / AppSizes.pillTileSize,
        ),
      ),
      child: Icon(icon, size: size * 0.5, color: foreground ?? shade.main),
    );
    if (badge == null) {
      return tile;
    }
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        tile,
        PositionedDirectional(
          bottom: -4,
          end: -4,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.surface,
                width: AppSizes.borderEmphasis,
              ),
            ),
            child: badge,
          ),
        ),
      ],
    );
  }
}
