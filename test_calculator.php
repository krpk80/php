<?php
require_once 'HeatLossCalculator.php';

$calculator = new HeatLossCalculator();

// Test Case 1: U = 1.5, Area = 10, Temp In = 20, Temp Out = 0
// Delta T = 20
// Q = 1.5 * 10 * 20 = 300 W
$heatLoss1 = $calculator->calculate(1.5, 10.0, 20.0, 0.0);

echo "Test 1: " . ($heatLoss1 === 300.0 ? "PASSED" : "FAILED (Expected 300.0, got $heatLoss1)") . "\n";

// Test Case 2: U = 0.5, Area = 50, Temp In = 22, Temp Out = -5
// Delta T = 27
// Q = 0.5 * 50 * 27 = 675 W
$heatLoss2 = $calculator->calculate(0.5, 50.0, 22.0, -5.0);

echo "Test 2: " . ($heatLoss2 === 675.0 ? "PASSED" : "FAILED (Expected 675.0, got $heatLoss2)") . "\n";
