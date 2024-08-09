import 'dart:io';
import 'package:face_net_authentication/pages/cocina_page.dart';
import 'package:face_net_authentication/pages/garage_page.dart';
import 'package:face_net_authentication/pages/sala_page.dart';
import 'package:face_net_authentication/pages/widgets/BluetoothService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'home.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';

class Profile extends StatefulWidget {
  const Profile(this.username, {Key? key, required this.imagePath})
      : super(key: key);
  final String username;
  final String imagePath;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late BluetoothService _bluetoothService;
  bool _bluetoothState = false;
  bool _isConnecting = false;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _deviceConnected;

  @override
  void initState() {
    super.initState();
    _bluetoothService = BluetoothService();
    _bluetoothService.bluetoothStateStream.listen((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  @override
  void dispose() {
    _bluetoothService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('es', null);

    String formattedDate =
        DateFormat('d \'de\' MMMM \'del\' yyyy', 'es').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF272727),
                                width: 10,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  FileImage(File(widget.imagePath)),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bienvenido, ${widget.username}',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildBluetoothControl(),
                    _buildDeviceInfo(),
                    _buildDeviceList(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildIconButton(Icons.meeting_room, 'SALA', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SalaPage(
                                    bluetoothService: _bluetoothService)),
                          );
                        }),
                        _buildIconButton(Icons.kitchen, 'COCINA', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CocinaPage(
                                    bluetoothService: _bluetoothService)),
                          );
                        }),
                        _buildIconButton(Icons.garage, 'GARAGE', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GaragePage(
                                    bluetoothService: _bluetoothService)),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: AppButton(
                text: "Salir",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                color: Color(0xFFFF6161),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBluetoothControl() {
    return SwitchListTile(
      value: _bluetoothState,
      onChanged: (bool value) async {
        if (value) {
          await _bluetoothService.bluetooth.requestEnable();
        } else {
          await _bluetoothService.bluetooth.requestDisable();
        }
        setState(() {
          _bluetoothState = value;
        });
      },
      tileColor: Colors.white,
      title: Text(
        _bluetoothState ? "Bluetooth encendido" : "Bluetooth apagado",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDeviceInfo() {
    return ListTile(
      tileColor: Colors.white,
      title: Text(
        "Conectado a: ${_bluetoothService.deviceConnected?.name ?? "ninguno"}",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      trailing: _bluetoothService.connection?.isConnected ?? false
          ? TextButton(
              onPressed: () async {
                await _bluetoothService.disconnect();
                setState(() {
                  _deviceConnected = null;
                });
              },
              child: const Text("Desconectar"),
            )
          : TextButton(
              onPressed: () async {
                await _bluetoothService.getDevices();
                setState(() {
                  _devices = _bluetoothService.devices;
                });
              },
              child: const Text("Ver dispositivos"),
            ),
    );
  }

  Widget _buildDeviceList() {
    return _bluetoothService.isConnecting
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  ...[
                    for (final device in _devices)
                      ListTile(
                        title: Text(device.name ?? device.address),
                        trailing: TextButton(
                          child: const Text('conectar'),
                          onPressed: () async {
                            await _bluetoothService.connectToDevice(device);
                            setState(() {
                              _deviceConnected =
                                  _bluetoothService.deviceConnected;
                              _devices = [];
                            });
                          },
                        ),
                      )
                  ]
                ],
              ),
            ),
          );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 30, color: Colors.white),
          onPressed: onPressed,
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }
}
