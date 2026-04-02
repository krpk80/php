import 'package:flutter_test/flutter_test.dart';
import 'package:heat_loss_calculator/gas_calculators.dart';

void main() {
  group('Gas Calculators Tests', () {
    test('GasConsumptionCalculator calculates correctly', () {
      final calc = GasConsumptionCalculator();
      // Power = 24 kW, Efficiency = 0.9
      // Consumption = (24 * 860) / (8250 * 0.9) = 20640 / 7425 = 2.77979...
      final result = calc.calculate(24.0, 0.9);
      expect(result, closeTo(2.78, 0.01));
    });

    test('GasVelocityCalculator calculates correctly', () {
      final calc = GasVelocityCalculator();
      // Flow Rate = 3.0 m³/h, Diameter = 20 mm
      // V = (3.0 / 3600) / (pi * (0.01)^2) = 0.0008333 / 0.000314159 = 2.652 m/s
      final result = calc.calculate(3.0, 20.0);
      expect(result, closeTo(2.65, 0.01));
    });

    test('VentilationCalculator enforces minimum and calculates correctly', () {
      final calc = VentilationCalculator();
      // Power = 20 kW -> 20 * 6 = 120 < 150 -> returns 150
      final resultSmall = calc.calculate(20.0);
      expect(resultSmall, 150.0);

      // Power = 30 kW -> 30 * 6 = 180 -> returns 180
      final resultLarge = calc.calculate(30.0);
      expect(resultLarge, 180.0);
    });
  });
}
