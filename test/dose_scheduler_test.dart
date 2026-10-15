import 'package:dose_tracker/core/utils/dose_scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DoseScheduler.distribute', () {
    test('keeps the old times for 1 and 2 doses', () {
      expect(DoseScheduler.distribute(1), <int>[480]);
      expect(DoseScheduler.distribute(2), <int>[480, 1200]);
    });

    test('three doses are 08:00, 14:00 and 20:00', () {
      expect(DoseScheduler.distribute(3), <int>[480, 840, 1200]);
    });

    test('every dose is between 07:00 and 22:00, never at midnight', () {
      for (int count = 1; count <= 6; count++) {
        expect(
          DoseScheduler.distribute(count),
          everyElement(inInclusiveRange(420, 1320)),
        );
      }
    });

    test('gives the requested count of sorted, unique times', () {
      for (int count = 1; count <= 6; count++) {
        final List<int> times = DoseScheduler.distribute(count);
        expect(times.length, count);
        expect(times.toSet().length, count);
        expect(times, <int>[...times]..sort());
      }
    });

    test('clamps a frequency outside 1 to 6', () {
      expect(DoseScheduler.distribute(0).length, 1);
      expect(DoseScheduler.distribute(9).length, 6);
    });
  });

  group('DoseScheduler.nextFreeMinute', () {
    test('starts at 08:00 when there are no times', () {
      expect(DoseScheduler.nextFreeMinute(<int>[]), 480);
    });

    test('adds one hour after the latest time', () {
      expect(DoseScheduler.nextFreeMinute(<int>[480, 1200]), 1260);
    });

    test('never goes past midnight', () {
      expect(DoseScheduler.nextFreeMinute(<int>[1380]), 480);
      expect(DoseScheduler.nextFreeMinute(<int>[480, 1380]), 540);
    });
  });
}
