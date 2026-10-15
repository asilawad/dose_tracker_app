import 'package:dose_tracker/core/utils/stock_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StockPolicy.isLow', () {
    test('is low when the stock equals the threshold', () {
      expect(StockPolicy.isLow(remaining: 5, threshold: 5), isTrue);
    });

    test('is low when the stock is below the threshold', () {
      expect(StockPolicy.isLow(remaining: 2, threshold: 5), isTrue);
      expect(StockPolicy.isLow(remaining: 0, threshold: 5), isTrue);
    });

    test('is not low when the stock is above the threshold', () {
      expect(StockPolicy.isLow(remaining: 6, threshold: 5), isFalse);
    });

    test('is never low when the stock or the threshold is unknown', () {
      expect(StockPolicy.isLow(remaining: null, threshold: 5), isFalse);
      expect(StockPolicy.isLow(remaining: 3, threshold: null), isFalse);
    });

    test('a new medication starts with a threshold of 5', () {
      expect(StockPolicy.defaultThreshold, 5);
    });
  });
}
