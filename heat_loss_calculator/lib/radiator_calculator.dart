class RadiatorCalculator {
  /// Calculates required radiator length (in meters).
  ///
  /// Standard PKKP 22 type panel radiators with 600mm height yield approximately
  /// 1600 to 1800 kcal/h heat output per running meter at 90/70 °C water regime.
  /// (approx 1800-2100 Watts per meter, specifically ~1950W average for Type 22/600).
  /// Let's use a standard metric:
  /// User provides required heat loss (in Watts) and the radiator's output per meter (in Watts/meter).
  ///
  /// [heatLossWatts] The calculated heat loss of the room in Watts.
  /// [radiatorOutputPerMeterWatts] The heat output of the chosen radiator type per meter (W/m).
  /// Default is usually around 1950 W/m for 600mm height PKKP 22 panel radiator.
  ///
  /// Returns required radiator length in meters.
  double calculate(double heatLossWatts, double radiatorOutputPerMeterWatts) {
    if (radiatorOutputPerMeterWatts <= 0) return 0;

    return heatLossWatts / radiatorOutputPerMeterWatts;
  }
}
