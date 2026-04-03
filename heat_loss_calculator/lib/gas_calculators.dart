import 'dart:math';

class GasConsumptionCalculator {
  /// Calculates natural gas consumption.
  ///
  /// The formula is typically Q = (Power / (Lower Heating Value * Efficiency))
  /// Natural gas lower heating value (Hu) is approx 8250 kcal/m³ or ~9.59 kWh/m³.
  /// We'll use 8250 kcal/m3 as standard in Turkey.
  /// 1 kW = 860 kcal/h.
  ///
  /// [powerKw] Appliance power in kW.
  /// [efficiency] Appliance efficiency (0.0 to 1.0, e.g., 0.9 for 90%).
  /// Returns consumption in m³/h.
  double calculate(double powerKw, double efficiency) {
    if (efficiency <= 0) return 0;
    // Power in kcal/h = powerKw * 860
    // Consumption = (Power in kcal/h) / (8250 * efficiency)
    double powerKcal = powerKw * 860;
    return powerKcal / (8250 * efficiency);
  }
}

class GasVelocityCalculator {
  /// Calculates gas velocity in a pipe.
  ///
  /// Formula: V = (354 * Q * (P_atm + P_gas)) / (D^2 * P_atm)  (approx simplified)
  /// A simpler and more common standard formula used in Turkey (TS 7363):
  /// V = (Q / (3600 * A)) where Q is flow rate at operating conditions
  /// Or simpler derived for low pressure: V = 353.677 * (Q / (D^2))
  /// Let's use the standard area formula: V = Q_volumetric / Area
  /// V (m/s) = (Q (m³/h) / 3600) / (pi * (D/1000/2)^2)
  ///
  /// [flowRate] Gas flow rate in m³/h
  /// [innerDiameterMm] Pipe inner diameter in millimeters
  /// Returns gas velocity in m/s
  double calculate(double flowRate, double innerDiameterMm) {
    if (innerDiameterMm <= 0) return 0;

    double flowRateM3PerS = flowRate / 3600.0;
    double radiusM = (innerDiameterMm / 1000.0) / 2.0;
    double areaM2 = pi * pow(radiusM, 2);

    return flowRateM3PerS / areaM2;
  }
}

class VentilationCalculator {
  /// Calculates required ventilation area (menfez) for natural gas appliances.
  ///
  /// According to TS 7363 standards, for appliances drawing combustion air from the room:
  /// Free cross-sectional area (S) >= Total Power (kW) * 6 cm² / kW.
  /// Minimum area is usually 150 cm².
  ///
  /// [totalPowerKw] Total installed power of appliances in the room in kW.
  /// Returns required ventilation area in cm².
  double calculate(double totalPowerKw) {
    double calculatedArea = totalPowerKw * 6.0; // 6 cm2 per kW

    // Minimum 150 cm2 is a common rule in TS7363, but we'll return the calculation
    // and let the UI handle the "Minimum 150" note if needed, or enforce it here.
    return calculatedArea < 150.0 ? 150.0 : calculatedArea;
  }
}
