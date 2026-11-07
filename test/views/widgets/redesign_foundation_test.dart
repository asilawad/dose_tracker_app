import 'package:dose_tracker/core/theme/app_theme.dart';
import 'package:dose_tracker/views/widgets/app_bottom_nav_bar.dart';
import 'package:dose_tracker/views/widgets/app_collapsing_header.dart';
import 'package:dose_tracker/views/widgets/app_inner_header.dart';
import 'package:dose_tracker/views/widgets/app_switch.dart';
import 'package:dose_tracker/views/widgets/bottom_nav_item.dart';
import 'package:dose_tracker/views/widgets/nav_bar_fade.dart';
import 'package:dose_tracker/views/widgets/nav_hop_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const List<BottomNavItem> _items = <BottomNavItem>[
  BottomNavItem(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    labelKey: 'one',
  ),
  BottomNavItem(
    icon: Icons.settings_outlined,
    activeIcon: Icons.settings_rounded,
    labelKey: 'two',
  ),
  BottomNavItem(
    icon: Icons.inventory_2_outlined,
    activeIcon: Icons.inventory_2_rounded,
    labelKey: 'three',
  ),
  BottomNavItem(
    icon: Icons.person_outlined,
    activeIcon: Icons.person_rounded,
    labelKey: 'four',
  ),
];

class _Harness extends StatefulWidget {
  const _Harness({
    required this.textDirection,
    required this.sliver,
    super.key,
  });

  final TextDirection textDirection;
  final Widget sliver;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: Directionality(
        textDirection: widget.textDirection,
        child: Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              CustomScrollView(
                slivers: <Widget>[
                  widget.sliver,
                  const SliverToBoxAdapter(child: SizedBox(height: 2000)),
                ],
              ),
              const NavBarFade(),
              AppBottomNavBar(
                items: _items,
                currentIndex: _index,
                onTap: (int index) => setState(() => _index = index),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double _indicatorCenterX(WidgetTester tester) {
  return tester.getCenter(find.byType(NavHopIndicator)).dx;
}

void main() {
  for (final TextDirection direction in TextDirection.values) {
    testWidgets('circle lands on the tapped tab in ${direction.name}', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _Harness(
          textDirection: direction,
          sliver: const AppCollapsingHeader(
            title: 'Title',
            eyebrowLabel: 'Today',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('three'));
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(find.text('two'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        _indicatorCenterX(tester),
        moreOrLessEquals(tester.getCenter(find.text('two')).dx, epsilon: 1),
      );
    });
  }

  testWidgets('headers stay pinned without overflow while scrolling', (
    WidgetTester tester,
  ) async {
    for (final Widget sliver in const <Widget>[
      AppCollapsingHeader(
        title: 'A title',
        eyebrowLabel: 'Today',
        eyebrowIcon: Icons.today_rounded,
      ),
      AppInnerHeader(title: 'Inner'),
    ]) {
      await tester.pumpWidget(
        _Harness(
          key: ValueKey<Widget>(sliver),
          textDirection: TextDirection.ltr,
          sliver: sliver,
        ),
      );
      await tester.pumpAndSettle();
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(BackdropFilter), findsOneWidget);
    }
  });

  testWidgets('switch reports taps', (WidgetTester tester) async {
    bool value = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: Center(
            child: AppSwitch(
              value: value,
              semanticLabel: 'Track stock',
              onChanged: (bool next) => value = next,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(AppSwitch));
    expect(value, isTrue);
  });
}
