import 'package:face_net_authentication/pages/widgets/BluetoothService.dart';
import 'package:flutter/material.dart';

class GaragePage extends StatefulWidget {
  final BluetoothService bluetoothService;

  const GaragePage({Key? key, required this.bluetoothService})
      : super(key: key);

  @override
  _GaragePageState createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage> {
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    // Inicializar el estado o realizar otras configuraciones necesarias.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.garage, color: Colors.white, size: 28.0),
            SizedBox(width: 16.0),
            Expanded(
              child: Text(
                'Garage',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.garage,
                    color: Colors.grey,
                    size: 200.0,
                  ),
                  SizedBox(height: 40.0),
                  _buildSwitch(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.garage,
            color: Colors.white,
            size: 40.0,
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Luces',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.white),
              ),
              const SizedBox(height: 16.0),
              Switch(
                value: _isSwitched,
                onChanged: (bool value) {
                  setState(() {
                    _isSwitched = value;
                    _sendData(value ? "1" : "0");
                  });
                },
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.red.withOpacity(0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendData(String data) {
    widget.bluetoothService.sendData(data);
  }
}
