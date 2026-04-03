import 'package:flutter/material.dart';
import 'heat_loss_calculator.dart';
import 'gas_calculators.dart';
import 'radiator_calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doğalgaz & Isı Hesapları',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HeatLossScreen(),
    GasCalculationsScreen(),
    RadiatorCalculationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mühendislik Hesapları'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'Isı Kaybı',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Doğalgaz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.heat_pump),
            label: 'Radyatör',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HeatLossScreen extends StatefulWidget {
  const HeatLossScreen({super.key});

  @override
  State<HeatLossScreen> createState() => _HeatLossScreenState();
}

class _HeatLossScreenState extends State<HeatLossScreen> {
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Isı Kaybı Hesabı', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField(_uValueController, 'U-Değeri (W/m²K)'),
            _buildTextField(_areaController, 'Yüzey Alanı (m²)'),
            _buildTextField(_tempInsideController, 'İç Ortam Sıcaklığı (°C)'),
            _buildTextField(_tempOutsideController, 'Dış Ortam Sıcaklığı (°C)', allowNegative: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _calculate, child: const Text('Hesapla')),
            if (_calculatedHeatLoss != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Isı Kaybı: ${_calculatedHeatLoss!.toStringAsFixed(2)} W',
                    style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool allowNegative = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: allowNegative),
        validator: (v) => (v == null || v.isEmpty || double.tryParse(v) == null) ? 'Geçerli sayı girin' : null,
      ),
    );
  }
}

class GasCalculationsScreen extends StatefulWidget {
  const GasCalculationsScreen({super.key});

  @override
  State<GasCalculationsScreen> createState() => _GasCalculationsScreenState();
}

class _GasCalculationsScreenState extends State<GasCalculationsScreen> {
  final _consFormKey = GlobalKey<FormState>();
  final _consPowerCtrl = TextEditingController();
  final _consEffCtrl = TextEditingController(text: "0.9");
  double? _calcCons;

  final _velFormKey = GlobalKey<FormState>();
  final _velFlowCtrl = TextEditingController();
  final _velDiaCtrl = TextEditingController();
  double? _calcVel;

  final _ventFormKey = GlobalKey<FormState>();
  final _ventPowerCtrl = TextEditingController();
  double? _calcVent;

  final GasConsumptionCalculator _consCalc = GasConsumptionCalculator();
  final GasVelocityCalculator _velCalc = GasVelocityCalculator();
  final VentilationCalculator _ventCalc = VentilationCalculator();

  void _calcConsumption() {
    if (_consFormKey.currentState!.validate()) {
      setState(() {
        _calcCons = _consCalc.calculate(
          double.parse(_consPowerCtrl.text),
          double.parse(_consEffCtrl.text),
        );
      });
    }
  }

  void _calcVelocity() {
    if (_velFormKey.currentState!.validate()) {
      setState(() {
        _calcVel = _velCalc.calculate(
          double.parse(_velFlowCtrl.text),
          double.parse(_velDiaCtrl.text),
        );
      });
    }
  }

  void _calcVentilation() {
    if (_ventFormKey.currentState!.validate()) {
      setState(() {
        _calcVent = _ventCalc.calculate(double.parse(_ventPowerCtrl.text));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Consumption Section
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _consFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Gaz Tüketimi (m³/h)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildTextField(_consPowerCtrl, 'Cihaz Gücü (kW)'),
                  _buildTextField(_consEffCtrl, 'Verim (0.0 - 1.0)'),
                  ElevatedButton(onPressed: _calcConsumption, child: const Text('Tüketim Hesapla')),
                  if (_calcCons != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Tüketim: ${_calcCons!.toStringAsFixed(2)} m³/h', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Velocity Section
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _velFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Gaz Hızı (m/s)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildTextField(_velFlowCtrl, 'Debi (m³/h)'),
                  _buildTextField(_velDiaCtrl, 'Boru İç Çapı (mm)'),
                  ElevatedButton(onPressed: _calcVelocity, child: const Text('Hız Hesapla')),
                  if (_calcVel != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Gaz Hızı: ${_calcVel!.toStringAsFixed(2)} m/s', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Ventilation Section
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _ventFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Menfez Alanı (cm²)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildTextField(_ventPowerCtrl, 'Toplam Cihaz Gücü (kW)'),
                  ElevatedButton(onPressed: _calcVentilation, child: const Text('Menfez Hesapla')),
                  if (_calcVent != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Gerekli Alan: ${_calcVent!.toStringAsFixed(2)} cm²', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (v) => (v == null || v.isEmpty || double.tryParse(v) == null) ? 'Geçerli sayı girin' : null,
      ),
    );
  }
}

class RadiatorCalculationScreen extends StatefulWidget {
  const RadiatorCalculationScreen({super.key});

  @override
  State<RadiatorCalculationScreen> createState() => _RadiatorCalculationScreenState();
}

class _RadiatorCalculationScreenState extends State<RadiatorCalculationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heatLossCtrl = TextEditingController();
  final _radOutputCtrl = TextEditingController(text: "1950");
  double? _calcLength;

  final RadiatorCalculator _calc = RadiatorCalculator();

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _calcLength = _calc.calculate(
          double.parse(_heatLossCtrl.text),
          double.parse(_radOutputCtrl.text),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Radyatör Metraj Hesabı', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField(_heatLossCtrl, 'Oda Isı Kaybı (W)'),
            _buildTextField(_radOutputCtrl, 'Radyatör Isıl Verimi (W/m)'),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _calculate, child: const Text('Hesapla')),
            if (_calcLength != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Gerekli Radyatör Uzunluğu: ${_calcLength!.toStringAsFixed(2)} m',
                    style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: (v) => (v == null || v.isEmpty || double.tryParse(v) == null) ? 'Geçerli sayı girin' : null,
      ),
    );
  }
}
