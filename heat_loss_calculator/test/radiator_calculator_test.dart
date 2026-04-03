import 'package:flutter_test/flutter_test.dart';
import 'package:heat_loss_calculator/radiator_calculator.dart';

void main() {
  group('RadiatorCalculator Tests', () {
    test('calculates required radiator length correctly', () {
      final calc = RadiatorCalculator();
      // Heat Loss = 2000 W, Output per meter = 1950 W/m
      // Length = 2000 / 1950 = 1.0256...
      final result = calc.calculate(2000.0, 1950.0);
      expect(result, closeTo(1.026, 0.001));
    });

    test('returns 0 when output per meter is zero or negative', () {
      final calc = RadiatorCalculator();
      expect(calc.calculate(2000.0, 0), 0);
      expect(calc.calculate(2000.0, -100), 0);
    });
  });
}
