// import 'package:face_net_authentication/constants/constants.dart';
import 'package:face_net_authentication/locator.dart';
import 'package:face_net_authentication/pages/db/databse_helper.dart';
import 'package:face_net_authentication/pages/sign-in.dart';
import 'package:face_net_authentication/pages/sign-up.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/ml_service.dart';
import 'package:face_net_authentication/services/face_detector_service.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MLService _mlService = locator<MLService>();
  FaceDetectorService _mlKitService = locator<FaceDetectorService>();
  CameraService _cameraService = locator<CameraService>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  _initializeServices() async {
    setState(() => loading = true);
    await _cameraService.initialize();
    await _mlService.initialize();
    _mlKitService.initialize();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, top: 20),
            child: PopupMenuButton<String>(
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'Clear DB':
                    DatabaseHelper _dataBaseHelper = DatabaseHelper.instance;
                    _dataBaseHelper.deleteAll();
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Clear DB'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
      body: !loading
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SafeArea(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Image and Text Column
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(image: AssetImage('assets/logo_face.png')),
                            ],
                          ),
                        ),

                        // Buttons Column
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SignIn()),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xFF0F0BDB),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.1),
                                        blurRadius: 1,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 16),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Iniciar sesión',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      SizedBox(width: 10),
                                      Icon(Icons.login, color: Colors.white)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SignUp()),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red,
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.1),
                                        blurRadius: 1,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 16),
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Registro',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      SizedBox(width: 10),
                                      Icon(Icons.person_add,
                                          color: Colors.white)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
