import 'package:dose_tracker/features/medications/controllers/dose_times_editor.dart';
import 'package:flutter_test/flutter_test.dart';

List<int> _minutes(DoseTimesEditor editor) {
  return editor.times.map((time) => time.minuteOfDay).toList();
}

DoseTimesEditor _three() {
  return DoseTimesEditor()
    ..increase()
    ..increase();
}

void main() {
  group('without manual edits', () {
    test('starts with one dose at 08:00', () {
      expect(_minutes(DoseTimesEditor()), <int>[480]);
    });

    test('increase and addTime use the distribution table', () {
      expect(_minutes(_three()), <int>[480, 840, 1200]);
      final DoseTimesEditor editor = DoseTimesEditor()..addTime();
      expect(_minutes(editor), <int>[480, 1200]);
    });

    test('decrease uses the distribution table', () {
      final DoseTimesEditor editor = _three()..decrease();
      expect(_minutes(editor), <int>[480, 1200]);
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
  });

  group('editing a time', () {
    test('the later times follow the edit', () {
      final DoseTimesEditor editor = _three();
      expect(editor.updateTime(index: 0, minuteOfDay: 600, quantity: 1), isTrue);
      expect(_minutes(editor), <int>[600, 960, 1320]);
    });

    test('a later pinned time does not move', () {
      final DoseTimesEditor editor = _three();
      editor.updateTime(index: 2, minuteOfDay: 1260, quantity: 1);
      editor.updateTime(index: 0, minuteOfDay: 540, quantity: 1);
      expect(_minutes(editor), <int>[540, 900, 1260]);
    });

    test('only the edited time moves when the others would leave the day', () {
      final DoseTimesEditor editor = _three();
      editor.updateTime(index: 0, minuteOfDay: 1000, quantity: 1);
      expect(_minutes(editor), <int>[840, 1000, 1200]);
    });

    test('rejects a used minute, a bad index and a minute outside the day', () {
      final DoseTimesEditor editor = _three();
      expect(
        editor.updateTime(index: 0, minuteOfDay: 840, quantity: 1),
        isFalse,
      );
      expect(
        editor.updateTime(index: 9, minuteOfDay: 600, quantity: 1),
        isFalse,
      );
      expect(
        editor.updateTime(index: 0, minuteOfDay: 1440, quantity: 1),
        isFalse,
      );
      expect(
        editor.updateTime(index: 0, minuteOfDay: -1, quantity: 1),
        isFalse,
      );
      expect(_minutes(editor), <int>[480, 840, 1200]);
    });
  });

  group('edits survive adding and removing times', () {
    test('adding a time keeps the edit and uses the largest gap', () {
      final DoseTimesEditor editor = _three();
      editor.updateTime(index: 1, minuteOfDay: 900, quantity: 1);
      expect(_minutes(editor), <int>[480, 900, 1260]);
      editor.increase();
      expect(_minutes(editor), <int>[480, 690, 900, 1260]);
    });

    test('adding times up to the maximum never undoes the edit', () {
      final DoseTimesEditor editor = _three();
      editor.updateTime(index: 1, minuteOfDay: 900, quantity: 1);
      while (editor.canIncrease) {
        editor.increase();
      }
      final List<int> minutes = _minutes(editor);
      expect(minutes.length, 6);
      expect(minutes, containsAll(<int>[900, 1260]));
      expect(minutes.toSet().length, 6);
      expect(minutes, <int>[...minutes]..sort());
    });

    test('an edited quantity survives adding a time', () {
      final DoseTimesEditor editor = DoseTimesEditor()..increase();
      editor.updateTime(index: 0, minuteOfDay: 480, quantity: 2);
      editor.increase();
      expect(_minutes(editor), <int>[480, 840, 1200]);
      expect(editor.times.first.quantity, 2);
      expect(editor.times[1].quantity, 1);
    });

    test('decrease drops the latest unpinned time first', () {
      final DoseTimesEditor editor = _three();
      editor.updateTime(index: 0, minuteOfDay: 600, quantity: 1);
      expect(_minutes(editor), <int>[600, 960, 1320]);
      editor.decrease();
      expect(_minutes(editor), <int>[600, 960]);
      editor.decrease();
      expect(_minutes(editor), <int>[600]);
      editor.decrease();
      expect(_minutes(editor), <int>[600]);
    });

    test('removeTime removes that time and pins the rest', () {
      final DoseTimesEditor editor = _three()..removeTime(0);
      expect(_minutes(editor), <int>[840, 1200]);
      editor.increase();
      expect(_minutes(editor), <int>[630, 840, 1200]);
    });

    test('removeTime ignores a bad index and keeps at least one time', () {
      final DoseTimesEditor editor = _three()..removeTime(9);
      expect(editor.frequency, 3);
      editor
        ..removeTime(0)
        ..removeTime(0)
        ..removeTime(0);
      expect(editor.frequency, 1);
    });
  });

  group('setTimes', () {
    test('sorts the times and pins them', () {
      final DoseTimesEditor editor = DoseTimesEditor()
        ..setTimes(<({int minuteOfDay, double quantity})>[
          (minuteOfDay: 900, quantity: 1),
          (minuteOfDay: 600, quantity: 2),
        ]);
      expect(_minutes(editor), <int>[600, 900]);
      expect(editor.times.first.quantity, 2);
      editor.increase();
      expect(_minutes(editor), <int>[600, 900, 1110]);
    });

    test('decrease removes the last time when all are pinned', () {
      final DoseTimesEditor editor = DoseTimesEditor()
        ..setTimes(<({int minuteOfDay, double quantity})>[
          (minuteOfDay: 480, quantity: 1),
          (minuteOfDay: 720, quantity: 1),
          (minuteOfDay: 1200, quantity: 1),
        ])
        ..decrease();
      expect(_minutes(editor), <int>[480, 720]);
    });

    test('an empty list resets to the default time', () {
      final DoseTimesEditor editor = _three()..setTimes(const []);
      expect(_minutes(editor), <int>[480]);
    });
  });
}
