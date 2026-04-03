class HeatLossCalculator {
  /// Calculate heat loss.
  ///
  /// [uValue] The U-value (thermal transmittance) of the material (W/m²K).
  /// [area] The surface area (m²).
  /// [tempInside] The inside temperature (°C).
  /// [tempOutside] The outside temperature (°C).
  /// Returns the calculated heat loss in Watts (W).
  double calculate(double uValue, double area, double tempInside, double tempOutside) {
    double deltaT = tempInside - tempOutside;
    return uValue * area * deltaT;
  }
}
