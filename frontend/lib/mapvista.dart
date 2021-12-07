import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as geo;
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatefulWidget {
  MapView({Key key, this.title = ''}) : super(key: key);
  final String title;

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
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
                      heroTag: "btnCurrentLocation",
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
                      heroTag: "btnMakePhoneCall",
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
    Geolocator().placemarkFromAddress(buscarDireccion).then((result) {
      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                  result[0].position.latitude, result[0].position.longitude),
              zoom: 10.0)));
    });
  }
}
