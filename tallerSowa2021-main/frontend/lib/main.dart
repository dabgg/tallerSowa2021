/*import 'dart:async';
import 'package:mytracker/login.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as geo;
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytracker/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginView(),
  ));

  //runApp(MyApp());
}

// WIDGET QUE ES UTILIZADO PARA EL LOGIN A LA APP
/*class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _MyAppFormState createState() => _MyAppFormState();
}

class User {
  String nickname;
  String password;
  User(this.nickname, this.password);
}

class _MyAppFormState extends State<LoginView> {
  Future save() async {
    var res = await http.post("http://localhost:8080/signin",
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
        body: <String, String>{
          'nickname': user.nickname,
          'password': user.password
        });
    print(res.body);
    /*Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Dashboard()));*/
  }

  User user = User('', '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.1,
                backgroundColor: Colors.blue,
                backgroundImage: AssetImage('assets/images/logoCamion.jpg'),
              ),
              Text(
                'Login',
                style: TextStyle(fontFamily: 'BebasNeue', fontSize: 40.0),
              ),
              SizedBox(
                width: 160.0,
                height: 60.0,
                child: Divider(color: Colors.black87),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: TextEditingController(text: user.nickname),
                  onChanged: (value) {
                    user.nickname = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Escribe algo';
                    } else if (value.length < 25) {
                      return 'El nickname debe ser de a lo menos 25 caracteres';
                    } else {
                      return 'Enter valid nickname';
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Ingrese nombre de usuario',
                      labelText: 'NOMBRE DE USUARIO',
                      suffixIcon: Icon(Icons.verified_user),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                width: 0.0,
                height: 10.0,
                child: Divider(color: Colors.black87),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: TextEditingController(text: user.password),
                  onChanged: (value) {
                    user.nickname = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Escribe algo';
                    } else if (value.length < 4) {
                      return 'El nickname debe ser de a lo menos 4 caracteres';
                    } else {
                      return 'Enter valid password';
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Ingrese contraseña',
                      labelText: 'CONTRASEÑA',
                      suffixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Divider(
                height: 15.0,
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(95, 20, 0, 0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => MyHomePage()));
                        },
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
              /*SizedBox(
                // ignore: todo
                /* EN ESTE SIZEDBOX TIENE QUE ESTAR TODO EL TEMA DE LA AUTH, SEGUN EL VIDEO QUE COMPARTI*/
                child: FlatButton(
                  hoverColor: Colors.lightBlue,
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 30.0,
                        fontFamily: 'BebasNeue'),
                  ),
                  color: Colors.blue,
                  
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (bc) => MyHomePage());
                    Navigator.of(context).push(route);
                  },
                ),
              ) //ESTE ES EL FINAL DE SIZEDBOX*/
            ],
          )
        ],
      ),
    );
  }
}
// FIN WIDGET LOGIN
*/
/*class MyApp extends StatelessWidget {
  // ESTE ES EL WIDGET ROOT/PRINCIPAL
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LoginView(),
    );
  }
}*/

/*class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title = ''}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isVisible = true;
  bool _darkMode = false;
  StreamSubscription _streamSubscription;
  geo.Location _tracker = geo.Location();
  Marker marker;
  Circle circle;
  GoogleMapController _googleMapController;
  String buscarDireccion;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(-33.047366, -71.419373),
    zoom: 14.4746,
  );

  //function menu options
  void showMenuOptions() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  //functions for call 911
  Future<void> _launched;
  String _phone = '911';
  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool switchValue = false;
  changeMapMode() {
    setState(() {
      if (_darkMode == true) {
        getJsonFile("assets/json/light.json").then(setMapStyle);
      } else {
        getJsonFile("assets/json/night.json").then(setMapStyle);
      }
    });
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _googleMapController.setMapStyle(mapStyle);
  }

  @override
  void dispose() {
    if (_streamSubscription != null) {
      _streamSubscription.cancel();
    }
    super.dispose();
  }

  //FUNCION PARA ACTUALIZAR EL MARCADOR
  void updateMarker(geo.LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("marcador"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.1, 0.1),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("camion"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  Future<Uint8List> getMarkerCar() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/images/camionfeo.png");
    return byteData.buffer.asUint8List();
  }

  //FUNCION PARA CAPTURAR LA POSICION ACTUAL
  void getCurrentLocationCar() async {
    try {
      Uint8List imageData = await getMarkerCar();
      var location = await _tracker.getLocation();

      updateMarker(location, imageData);

      if (_streamSubscription != null) {
        _streamSubscription.cancel();
      }

      _streamSubscription = _tracker.onLocationChanged.listen((newLocalData) {
        if (_googleMapController != null) {
          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 100,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarker(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_darkMode) {
      setState(() {
        changeMapMode();
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: new IconButton(
          icon: new Icon(Icons.menu),
          onPressed: () {
            showMenuOptions();
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              zoomGesturesEnabled: true,
              initialCameraPosition: initialLocation,
              markers: Set.of((marker != null) ? [marker] : []),
              circles: Set.of((circle != null) ? [circle] : []),
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
              },
            ),
          ),
          Positioned(
            top: 30.0,
            right: 15.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: barraBusqueda,
                    iconSize: 30.0,
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    buscarDireccion = val;
                  });
                },
              ),
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: Container(
              margin: EdgeInsets.only(top: 80, right: 10),
              alignment: Alignment.centerLeft,
              color: Color(0xFF808080).withOpacity(0.5),
              height: 200,
              width: 70,
              child: Column(children: <Widget>[
                SizedBox(
                  width: 10.0,
                ),
                new Switch(
                  activeColor: Colors.black87,
                  onChanged: (newValue) {
                    setState(() {
                      this.switchValue = newValue;
                      _darkMode = newValue;
                      changeMapMode();
                      //print('Changing the Map Type');
                    });
                  },
                  value: switchValue,
                ),
                /* SizedBox(width: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      child: Icon(Icons.directions_bike),
                      elevation: 5,
                      backgroundColor: Colors.greenAccent,
                      onPressed: () {
                        // setState(() {
                        //   _darkMode = false;
                        //   changeMapMode();
                        // });
                      }),
                ),*/
                SizedBox(width: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      child: Icon(Icons.location_searching),
                      elevation: 5,
                      backgroundColor: Colors.blueAccent,
                      onPressed: () {
                        getCurrentLocationCar();
                      }),
                ),
                /*SizedBox(width: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      child: Icon(Icons.local_taxi),
                      elevation: 5,
                      backgroundColor: Colors.orangeAccent,
                      onPressed: () {
                        //getCurrentLocation();
                      }),
                ),*/
                /*SizedBox(width: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      child: Icon(
                        Icons.notification_important,
                        color: Colors.yellow,
                      ),
                      elevation: 5,
                      backgroundColor: Colors.purple[300],
                      onPressed: () {
                        //getCurrentLocation();
                      }),
                ),*/
                SizedBox(width: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                      child: Icon(
                        Icons.phone,
                        color: Colors.pinkAccent,
                      ),
                      elevation: 5,
                      backgroundColor: Colors.white,
                      onPressed: () => setState(() {
                            _launched = _makePhoneCall('tel:$_phone');
                          })),
                ),
                /*Positioned(
                  top: 30.0,
                  right: 15.0,
                  left: 15.0,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: barraBusqueda,
                          iconSize: 30.0,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          buscarDireccion = val;
                        });
                      },
                    ),
                  ),
                ),*/
              ]),
            ),
          )
        ],
      ),
    );
  }

  barraBusqueda() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 10.0,
        )),
      );
    });
  }
}*/
