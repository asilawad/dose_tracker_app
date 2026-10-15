import 'package:dose_tracker/features/medications/controllers/dose_times_editor.dart';
import 'package:flutter_test/flutter_test.dart';

List<int> _minutes(DoseTimesEditor editor) {
  return editor.times.map((time) => time.minuteOfDay).toList();
}

void main() {
  group('DoseTimesEditor', () {
    test('starts with one dose at 08:00', () {
      expect(_minutes(DoseTimesEditor()), <int>[480]);
    });

    test('increase redistributes the times', () {
      final DoseTimesEditor editor = DoseTimesEditor()
        ..increase()
        ..increase();
      expect(_minutes(editor), <int>[480, 840, 1200]);
    });

    test('never goes above six or below one time', () {
      final DoseTimesEditor editor = DoseTimesEditor();
      editor.decrease();
      expect(editor.frequency, 1);
      for (int i = 0; i < 10; i++) {
        editor.increase();
      }
      expect(editor.frequency, 6);
      expect(editor.canIncrease, isFalse);
    });

    test('addTime adds an hour after the latest and keeps the others', () {
      final DoseTimesEditor editor = DoseTimesEditor()
        ..increase()
        ..addTime();
      expect(_minutes(editor), <int>[480, 1200, 1260]);
    });

    test('removeTime removes one time and ignores a bad index', () {
      final DoseTimesEditor editor = DoseTimesEditor()
        ..increase()
        ..increase()
        ..removeTime(9)
        ..removeTime(1);
      expect(_minutes(editor), <int>[480, 1200]);
    });

    test('updateTime changes a time and keeps the list sorted', () {
      final DoseTimesEditor editor = DoseTimesEditor()
        ..increase()
        ..increase();
      final bool changed = editor.updateTime(
        index: 0,
        minuteOfDay: 900,
        quantity: 2,
      );
      expect(changed, isTrue);
      expect(_minutes(editor), <int>[840, 900, 1200]);
      expect(editor.times[1].quantity, 2);
    });

    test('updateTime rejects a minute that is already used', () {
      final DoseTimesEditor editor = DoseTimesEditor()
        ..increase()
        ..increase();
      final bool changed = editor.updateTime(
        index: 0,
        minuteOfDay: 840,
        quantity: 1,
      );
      expect(changed, isFalse);
      expect(_minutes(editor), <int>[480, 840, 1200]);
    });

    test('updateTime rejects an invalid index', () {
      final DoseTimesEditor editor = DoseTimesEditor();
      final bool changed = editor.updateTime(
        index: 3,
        minuteOfDay: 600,
        quantity: 1,
      );
      expect(changed, isFalse);
    });
  });
}
