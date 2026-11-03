import 'dart:ui' show lerpDouble;

import 'package:dose_tracker/core/constants/app_durations.dart';
import 'package:dose_tracker/core/constants/app_sizes.dart';
import 'package:dose_tracker/core/theme/app_color_tokens.dart';
import 'package:flutter/material.dart';

/// The gradient circle that hops between tabs: it slides across while rising
/// in an arc, lands with a squash, and settles.
///
/// Position is kept as a fractional tab index, so a resize never desyncs it
/// and a tap during a hop continues from wherever the circle is. Must be a
/// direct child of a `Stack`; the directional position mirrors it in RTL.
class NavHopIndicator extends StatefulWidget {
  const NavHopIndicator({
    required this.index,
    required this.slotWidth,
    super.key,
  });

  final int index;
  final double slotWidth;

  @override
  State<NavHopIndicator> createState() => _NavHopIndicatorState();
}

class _NavHopIndicatorState extends State<NavHopIndicator>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _lift = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: 0,
          end: AppSizes.navHopPeak,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: AppSizes.navHopRisePhase,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: AppSizes.navHopPeak,
          end: AppSizes.navHopLanding,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: AppSizes.navHopFallPhase,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: AppSizes.navHopLanding, end: 0),
        weight: AppSizes.navHopSettlePhase,
      ),
    ],
  );

  static final Animatable<double> _scaleX = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1, end: AppSizes.navHopShrink),
        weight: AppSizes.navHopRisePhase,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(
          begin: AppSizes.navHopShrink,
          end: AppSizes.navHopStretch,
        ),
        weight: AppSizes.navHopFallPhase,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: AppSizes.navHopStretch, end: 1),
        weight: AppSizes.navHopSettlePhase,
      ),
    ],
  );

  static final Animatable<double> _scaleY = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1, end: AppSizes.navHopShrink),
        weight: AppSizes.navHopRisePhase,
      ),
      TweenSequenceItem<double>(
        tween: ConstantTween<double>(AppSizes.navHopShrink),
        weight: AppSizes.navHopFallPhase,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: AppSizes.navHopShrink, end: 1),
        weight: AppSizes.navHopSettlePhase,
      ),
    ],
  );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.navHop,
    value: 1,
  );
  late double _fromIndex = widget.index.toDouble();

  double get _currentIndex => lerpDouble(
    _fromIndex,
    widget.index.toDouble(),
    AppDurations.emphasizedCurve.transform(_controller.value),
  )!;

  @override
  void didUpdateWidget(NavHopIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index == widget.index) {
      return;
    }
    _fromIndex = lerpDouble(
      _fromIndex,
      oldWidget.index.toDouble(),
      AppDurations.emphasizedCurve.transform(_controller.value),
    )!;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
      return;
    }
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColorTokens colors = context.appColors;
    final double centering =
        (widget.slotWidth - AppSizes.navIndicatorSize) / 2;

    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double t = _controller.value;

        return PositionedDirectional(
          top: 0,
          start: _currentIndex * widget.slotWidth + centering,
          child: Transform.translate(
            offset: Offset(0, _lift.transform(t)),
            child: Transform.scale(
              scaleX: _scaleX.transform(t),
              scaleY: _scaleY.transform(t),
              child: child,
            ),
          ),
        );
      },
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: colors.actionGradient,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: colors.appBackground,
                spreadRadius: AppSizes.navIndicatorRing,
              ),
              BoxShadow(
                color: colors.shadowIndicator,
                blurRadius: AppSizes.navIndicatorBlur,
                offset: const Offset(0, AppSizes.navIndicatorOffsetY),
              ),
            ],
          ),
          child: const SizedBox.square(dimension: AppSizes.navIndicatorSize),
        ),
      ),
    );
  }
}
