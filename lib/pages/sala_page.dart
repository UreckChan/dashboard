import 'package:face_net_authentication/pages/widgets/BluetoothService.dart';
import 'package:flutter/material.dart';

class SalaPage extends StatefulWidget {
  final BluetoothService bluetoothService;

  const SalaPage({Key? key, required this.bluetoothService}) : super(key: key);

  @override
  _SalaPageState createState() => _SalaPageState();
}

class _SalaPageState extends State<SalaPage> {
  bool _isSwitched = false;

  @override
  void initState() {
    super.initState();
    // Utiliza el servicio de Bluetooth recibido y otros estados si es necesario.
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
            Icon(Icons.meeting_room, color: Colors.white, size: 28.0),
            SizedBox(width: 16.0),
            Expanded(
              child: Text(
                'Página Sala',
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
                    Icons.lightbulb_outline,
                    color: Colors.yellow,
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
            Icons.lightbulb_outline,
            color: Colors.white,
            size: 40.0,
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Foco',
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
                    _sendData(value ? '1' : '0');
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
