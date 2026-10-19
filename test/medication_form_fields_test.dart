import 'package:dose_tracker/core/utils/stock_policy.dart';
import 'package:dose_tracker/features/medications/controllers/medication_form_fields.dart';
import 'package:dose_tracker/features/medications/data/models/medication_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MedicationFormFields', () {
    late MedicationFormFields fields;

    setUp(() {
      fields = MedicationFormFields();
    });

    tearDown(() {
      fields.dispose();
    });

    test('stock fields are not validated while inventory tracking is off', () {
      for (final String? value in <String?>[null, '', '0', 'invalid']) {
        expect(fields.validateStock(value), isNull);
        expect(fields.validateThreshold(value), isNull);
      }
    });

    test('stock fields reject empty, zero, and non-numeric values when on', () {
      fields.setTrackInventory(true);
      for (final String? value in <String?>[null, '', '0', 'invalid']) {
        expect(fields.validateStock(value), isNotNull);
        expect(fields.validateThreshold(value), isNotNull);
      }
    });

    test('stock threshold defaults for empty or invalid input', () {
      expect(fields.stockThreshold, StockPolicy.defaultThreshold);
      fields.thresholdController.text = 'invalid';
      expect(fields.stockThreshold, StockPolicy.defaultThreshold);
      fields.thresholdController.text = '12';
      expect(fields.stockThreshold, 12);
    });

    test('dose and stock values parse valid values and reject invalid ones', () {
      fields.doseController.text = '2.5';
      fields.stockController.text = '12';
      expect(fields.doseAmount, 2.5);
      expect(fields.currentStock, 12);

      fields.doseController.text = 'invalid';
      fields.stockController.text = '0';
      expect(fields.doseAmount, isNull);
      expect(fields.currentStock, isNull);
    });

    test('tapping the selected meal instruction clears it', () {
      fields.selectMeal(MealInstruction.withMeal);
      expect(fields.mealInstruction.value, MealInstruction.withMeal);
      fields.selectMeal(MealInstruction.withMeal);
      expect(fields.mealInstruction.value, isNull);
    });

    test('starts with exactly one dose at 08:00', () {
      expect(fields.times, hasLength(1));
      expect(
        fields.times.single.minuteOfDay,
        Duration.minutesPerHour * 8,
      );
    });
  });
}
