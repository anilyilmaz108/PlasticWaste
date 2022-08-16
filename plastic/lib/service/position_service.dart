import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class PositionService extends ChangeNotifier{
  static Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  static double? long, lat;
  late StreamSubscription<Position> positionStream;

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        super.notifyListeners();

        getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    super.notifyListeners();
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude;
    lat = position.latitude;

    super.notifyListeners();

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude;
      lat = position.latitude;

      super.notifyListeners();
    });
  }

  void add(String title, String subtitle) {
    checkGps();
    var uuid = const Uuid();
    final MarkerId markerId = MarkerId("marker_${uuid.v1()}");

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat!,long!),
      infoWindow: InfoWindow(title: title, snippet: subtitle),
    );

    super.notifyListeners();
    markers[markerId] = marker;

  }
}