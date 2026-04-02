import 'package:flutter/material.dart';
import 'heat_loss_calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isı Kaybı Hesaplama',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HeatLossHomePage(title: 'Isı Kaybı Hesaplama'),
    );
  }
}

class HeatLossHomePage extends StatefulWidget {
  const HeatLossHomePage({super.key, required this.title});

  final String title;

  @override
  State<HeatLossHomePage> createState() => _HeatLossHomePageState();
}

class _HeatLossHomePageState extends State<HeatLossHomePage> {
  final _formKey = GlobalKey<FormState>();

  final _uValueController = TextEditingController();
  final _areaController = TextEditingController();
  final _tempInsideController = TextEditingController();
  final _tempOutsideController = TextEditingController();

  double? _calculatedHeatLoss;
  final HeatLossCalculator _calculator = HeatLossCalculator();

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final uValue = double.parse(_uValueController.text);
      final area = double.parse(_areaController.text);
      final tempInside = double.parse(_tempInsideController.text);
      final tempOutside = double.parse(_tempOutsideController.text);

      setState(() {
        _calculatedHeatLoss = _calculator.calculate(uValue, area, tempInside, tempOutside);
      });
    }
  }

  @override
  void dispose() {
    _uValueController.dispose();
    _areaController.dispose();
    _tempInsideController.dispose();
    _tempOutsideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _uValueController,
                decoration: const InputDecoration(
                  labelText: 'U-Değeri (W/m²K)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir değer girin';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir sayı girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: 'Yüzey Alanı (m²)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir değer girin';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir sayı girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tempInsideController,
                decoration: const InputDecoration(
                  labelText: 'İç Ortam Sıcaklığı (°C)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir değer girin';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir sayı girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tempOutsideController,
                decoration: const InputDecoration(
                  labelText: 'Dış Ortam Sıcaklığı (°C)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir değer girin';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir sayı girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Hesapla', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 24),
              if (_calculatedHeatLoss != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Text(
                    'Toplam Isı Kaybı: ${_calculatedHeatLoss!.toStringAsFixed(2)} W',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
