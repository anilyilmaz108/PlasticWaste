import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plastic/model/sample_model.dart';
import 'package:http/http.dart' as http;
import 'package:plastic/service/database_service.dart';
import 'package:plastic/service/position_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class LocationView extends StatefulWidget {
  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  Completer<GoogleMapController> _controller = Completer();

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  double long = 0.0, lat = 0.0;
  late StreamSubscription<Position> positionStream;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> _add(double lat, double long, String title, String subtitle)async {
    var uuid = Uuid();
    final MarkerId markerId = MarkerId("marker_${uuid.v1()}");
    //final String image = "assets/images/2.png";
/*BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(), image,
    );*/




    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(lat,long),
      infoWindow: InfoWindow(title: title, snippet: subtitle),
      //icon: markerbitmap,
    );

    PositionService.markers[markerId] = marker;
    //setState(() {// adding a new marker to map});
  }

  @override
  void initState() {
    Provider.of<PositionService>(context,listen: false).checkGps();
    Provider.of<DatabaseService>(context,listen: false).getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SampleModel>>(
        future: Provider.of<DatabaseService>(context,listen: false).getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for(int i = 0; i < snapshot.data!.length; i++){
              _add(double.parse('${snapshot.data![i].lat}'), double.parse('${snapshot.data![i].lng}'), '${snapshot.data![i].title}', '${snapshot.data![i].subtitle}');
            }
            return GoogleMap(
                onMapCreated: _onMapCreated,
                markers: Set<Marker>.of(PositionService.markers.values),
                initialCameraPosition: CameraPosition(
                  target: LatLng(36.8709,30.5200), //LatLng(lat,long)
                  zoom: 11.0,
                ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      )
    );
  }
}
