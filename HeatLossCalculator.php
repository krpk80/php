<?php

class HeatLossCalculator {
    /**
     * Calculate heat loss.
     *
     * @param float $uValue The U-value (thermal transmittance) of the material (W/m²K).
     * @param float $area The surface area (m²).
     * @param float $tempInside The inside temperature (°C).
     * @param float $tempOutside The outside temperature (°C).
     * @return float The calculated heat loss in Watts (W).
     */
    public function calculate(float $uValue, float $area, float $tempInside, float $tempOutside): float {
        $deltaT = $tempInside - $tempOutside;
        return $uValue * $area * $deltaT;
    }
}
