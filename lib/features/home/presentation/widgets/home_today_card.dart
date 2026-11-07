import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/constants/app_strings.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:dose_tracker/core/utils/dose_formatter.dart';
import 'package:dose_tracker/features/schedule/data/models/scheduled_dose.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Gradient hero on the Home tab (design `.hero`): the doses taken today
/// across the family, with one segment per dose, and the [next] dose to
/// take, if any, as a tappable row that calls [onNextTap].
class HomeTodayCard extends StatelessWidget {
  const HomeTodayCard({
    required this.taken,
    required this.total,
    this.next,
    this.onNextTap,
    super.key,
  });

  final int taken;
  final int total;
  final ScheduledDose? next;
  final VoidCallback? onNextTap;

  /// Above this many doses the segments become a single bar.
  static const int _maxSegments = 24;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color onHero = colors.onActive;

    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: colors.actionGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusHero),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.shadowActive,
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusHero),
          child: Stack(
            children: <Widget>[
              PositionedDirectional(
                top: -70,
                end: -60,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: onHero.withValues(alpha: 0.13),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSizes.spaceXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Semantics(
                      label: AppStrings.homeTakenToday.tr,
                      value: '$taken / $total',
                      child: ExcludeSemantics(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppStrings.homeTakenToday.tr,
                              style: textTheme.bodyMedium?.copyWith(
                                color: onHero.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '$taken',
                                    style: textTheme.displayLarge?.copyWith(
                                      color: onHero,
                                      fontSize: 46,
                                      height: 1,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' / $total',
                                    style: textTheme.titleLarge?.copyWith(
                                      color: onHero.withValues(alpha: 0.8),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSizes.spaceLg),
                            _Segments(
                              taken: taken,
                              total: total,
                              color: onHero,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (next != null) ...<Widget>[
                      const SizedBox(height: AppSizes.spaceLg),
                      _NextRow(dose: next!, color: onHero, onTap: onNextTap),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The glass row in the hero: clock, "Next: name for profile" and the time.
class _NextRow extends StatelessWidget {
  const _NextRow({required this.dose, required this.color, this.onTap});

  final ScheduledDose dose;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusLg);
    final String time = DoseFormatter.minuteOfDay(dose.minuteOfDay);
    final String label = AppStrings.homeNextDose.trParams(<String, String>{
      'name': dose.medicationName,
      'profile': dose.profileName,
    });

    return Semantics(
      button: onTap != null,
      label: '$label, $time',
      child: ExcludeSemantics(
        child: Material(
          color: color.withValues(alpha: 0.2),
          borderRadius: radius,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: <Widget>[
                  Icon(Icons.schedule_rounded, color: color),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: color,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    time,
                    style: textTheme.titleSmall?.copyWith(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Segments extends StatelessWidget {
  const _Segments({
    required this.taken,
    required this.total,
    required this.color,
  });

  final int taken;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final Color idle = color.withValues(alpha: 0.3);
    final BorderRadius radius = BorderRadius.circular(AppSizes.radiusFull);
    const double height = 6;

    if (total == 0 || total > HomeTodayCard._maxSegments) {
      final double fraction = total == 0 ? 0 : (taken / total).clamp(0, 1);
      return Container(
        height: height,
        decoration: BoxDecoration(color: idle, borderRadius: radius),
        alignment: AlignmentDirectional.centerStart,
        child: FractionallySizedBox(
          widthFactor: fraction,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color, borderRadius: radius),
            child: const SizedBox.expand(),
          ),
        ),
      );
    }
    return Row(
      children: <Widget>[
        for (int i = 0; i < total; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: AppSizes.spaceXs),
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: i < taken ? color : idle,
                borderRadius: radius,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
