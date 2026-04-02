<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Isı Kaybı Hesaplama Motoru</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f4f9;
            color: #333;
        }
        .container {
            max-width: 500px;
            margin: 0 auto;
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        h1 {
            text-align: center;
            font-size: 24px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="number"] {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .result {
            margin-top: 20px;
            padding: 15px;
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
            border-radius: 4px;
            text-align: center;
            font-size: 18px;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Isı Kaybı Hesaplama</h1>
    <form method="POST" action="">
        <div class="form-group">
            <label for="u_value">U-Değeri (W/m²K):</label>
            <input type="number" step="0.01" id="u_value" name="u_value" required value="<?= isset($_POST['u_value']) ? htmlspecialchars($_POST['u_value']) : '' ?>">
        </div>
        <div class="form-group">
            <label for="area">Yüzey Alanı (m²):</label>
            <input type="number" step="0.01" id="area" name="area" required value="<?= isset($_POST['area']) ? htmlspecialchars($_POST['area']) : '' ?>">
        </div>
        <div class="form-group">
            <label for="temp_inside">İç Ortam Sıcaklığı (°C):</label>
            <input type="number" step="0.1" id="temp_inside" name="temp_inside" required value="<?= isset($_POST['temp_inside']) ? htmlspecialchars($_POST['temp_inside']) : '' ?>">
        </div>
        <div class="form-group">
            <label for="temp_outside">Dış Ortam Sıcaklığı (°C):</label>
            <input type="number" step="0.1" id="temp_outside" name="temp_outside" required value="<?= isset($_POST['temp_outside']) ? htmlspecialchars($_POST['temp_outside']) : '' ?>">
        </div>
        <button type="submit">Hesapla</button>
    </form>

    <?php
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        require_once 'HeatLossCalculator.php';

        $uValue = isset($_POST['u_value']) ? (float)$_POST['u_value'] : 0.0;
        $area = isset($_POST['area']) ? (float)$_POST['area'] : 0.0;
        $tempInside = isset($_POST['temp_inside']) ? (float)$_POST['temp_inside'] : 0.0;
        $tempOutside = isset($_POST['temp_outside']) ? (float)$_POST['temp_outside'] : 0.0;

        $calculator = new HeatLossCalculator();
        $heatLoss = $calculator->calculate($uValue, $area, $tempInside, $tempOutside);

        echo "<div class='result'>Toplam Isı Kaybı: " . number_format($heatLoss, 2) . " W</div>";
    }
    ?>
</div>

</body>
</html>
