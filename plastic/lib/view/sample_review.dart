import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plastic/extensions/locale_keys.dart';
import 'package:plastic/model/sample_model.dart';

class SampleReview extends StatefulWidget {
  SampleModel _sampleModel;
  SampleReview(this._sampleModel);
  @override
  State<SampleReview> createState() => _SampleReviewState();
}

class _SampleReviewState extends State<SampleReview> {
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Set<Marker> _createMarker() {
    return {
      Marker(
          markerId: MarkerId("marker_1"),
          position: LatLng(widget._sampleModel.lat, widget._sampleModel.lng),
          infoWindow: InfoWindow(title: '${widget._sampleModel.title}', snippet: '${widget._sampleModel.subtitle}'),
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width:  MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(File('${widget._sampleModel.files}')),
                        fit: BoxFit.contain,
                      )
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Center(child: Text('${widget._sampleModel.title!}',style: TextStyle(fontSize: 20),)),
              SizedBox(height: 5,),
              Center(child: Text('${widget._sampleModel.subtitle!}',style: TextStyle(fontSize: 16, color: Colors.grey.shade500),)),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LocaleKeys.sample_review_title_1.tr(),style: TextStyle(fontSize: 16),),
                  Text('${widget._sampleModel.datetime!.split('T')[0]}',style: TextStyle(fontSize: 16, color: Colors.grey.shade600),)
                ],
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Material(
                  elevation: 2.0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: Center(child: Text(LocaleKeys.sample_review_title_2.tr(),style: TextStyle(fontSize: 18),)),

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    markers: _createMarker(),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget._sampleModel.lat,widget._sampleModel.lng),
                      zoom: 11.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


