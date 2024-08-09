import 'package:face_net_authentication/pages/widgets/BluetoothService.dart';
import 'package:flutter/material.dart';

class CocinaPage extends StatefulWidget {
  final BluetoothService bluetoothService;

  const CocinaPage({Key? key, required this.bluetoothService})
      : super(key: key);

  @override
  _CocinaPageState createState() => _CocinaPageState();
}

class _CocinaPageState extends State<CocinaPage> {
  bool _isSwitched = false;
  String temp = "--";

  @override
  void initState() {
    super.initState();
    _startReceivingData();
  }

  void _startReceivingData() {
    try {
      widget.bluetoothService.connection?.input?.listen((data) {
        setState(() {
          temp = String.fromCharCodes(data).trim();
          print("Datos recibidos: " + temp);
        });
      }).onDone(() {
        print('Bluetooth data stream closed');
      });
    } catch (e) {
      print("Error al recibir datos: $e");
    }
  }

  @override
  void dispose() {
    widget.bluetoothService.disconnect();
    super.dispose();
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
            Icon(Icons.kitchen, color: Colors.white, size: 28.0),
            SizedBox(width: 16.0),
            Expanded(
              child: Text(
                'Página Cocina',
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
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 5,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$temp°',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'C°',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
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
            Icons.kitchen,
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
    if (widget.bluetoothService.connection?.isConnected ?? false) {
      widget.bluetoothService.sendData(data);
    } else {
      print("No hay conexión Bluetooth para enviar datos.");
    }
  }
}
