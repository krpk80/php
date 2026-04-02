import 'package:flutter_test/flutter_test.dart';
import 'package:heat_loss_calculator/heat_loss_calculator.dart';

void main() {
  group('HeatLossCalculator Tests', () {
    final calculator = HeatLossCalculator();

    test('calculates heat loss correctly with positive temperatures', () {
      // Test Case 1: U = 1.5, Area = 10, Temp In = 20, Temp Out = 0
      // Delta T = 20
      // Q = 1.5 * 10 * 20 = 300 W
      final heatLoss = calculator.calculate(1.5, 10.0, 20.0, 0.0);
      expect(heatLoss, 300.0);
    });

    test('calculates heat loss correctly with negative outside temperature', () {
      // Test Case 2: U = 0.5, Area = 50, Temp In = 22, Temp Out = -5
      // Delta T = 27
      // Q = 0.5 * 50 * 27 = 675 W
      final heatLoss = calculator.calculate(0.5, 50.0, 22.0, -5.0);
      expect(heatLoss, 675.0);
    });

    test('calculates heat loss correctly when inside temp is lower than outside', () {
      // Test Case 3: U = 2.0, Area = 15, Temp In = 18, Temp Out = 30
      // Delta T = -12
      // Q = 2.0 * 15 * (-12) = -360 W
      final heatLoss = calculator.calculate(2.0, 15.0, 18.0, 30.0);
      expect(heatLoss, -360.0);
    });
  });
}
