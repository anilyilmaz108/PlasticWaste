import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plastic/extensions/locale_keys.dart';
import 'package:plastic/service/database_service.dart';
import 'package:plastic/service/image_service.dart';
import 'package:plastic/service/notification_service.dart';
import 'package:plastic/service/position_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GetSampleView extends StatefulWidget {
  const GetSampleView({Key? key}) : super(key: key);

  @override
  State<GetSampleView> createState() => _GetSampleViewState();
}

class _GetSampleViewState extends State<GetSampleView> {
  var uuid = Uuid();
  //String? token = " ";

  /*void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
            (token) {
              print(token);
          setState(() {
            token = token;
          });
        }
    );
  }*/


  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  File? file;

  Future<void> _refresh(){
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.register_view_refresh_title_1.tr(),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(LocaleKeys.register_view_refresh_title_2.tr(),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(LocaleKeys.register_view_refresh_title_3.tr(),),
              onPressed: () {
                setState(() {
                  file = ImageService.file;
                  print(file);
                  ImageService.file = null;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override



  void initState() {
    Provider.of<PositionService>(context, listen: false).checkGps();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    Provider.of<NotificationService>(context, listen: false).requestPermission();
    Provider.of<NotificationService>(context, listen: false).loadFCM();
    Provider.of<NotificationService>(context, listen: false).listenFCM();
    //getToken();
    FirebaseMessaging.instance.subscribeToTopic("Samples");

    super.initState();
  }
  @override
  void dispose() {
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    super.dispose();
  }

  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  double long = 0.0, lat = 0.0;
  late StreamSubscription<Position> positionStream;
  String dropdownValue = LocaleKeys.get_sample_view_sample_1.tr();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
              LocaleKeys.get_sample_view_title_1.tr(),
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              file == null
                  ? GestureDetector(
                onTap: () {
                  Provider.of<ImageService>(context, listen: false).showImageDialog(context).then((value) => _refresh());
                },
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: NetworkImage('https://icon-library.com/images/add-image-icon-png/add-image-icon-png-22.jpg'),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              )
                  : GestureDetector(
                onTap: () {
                  Provider.of<ImageService>(context,listen: false).showImageDialog(context).then((value) => _refresh());
                },
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      image: FileImage(file!),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 33.0),
                child: Text(
                    LocaleKeys.get_sample_view_title_2.tr(),
                  style: TextStyle(fontSize: 15, color: Colors.black45),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.0),
                child: TextField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: LocaleKeys.get_sample_view_title_3.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.0),
                child: TextField(
                  controller: _subtitleController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.subtitles),
                    hintText: LocaleKeys.get_sample_view_title_4.tr(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[LocaleKeys.get_sample_view_sample_1.tr(), LocaleKeys.get_sample_view_sample_2.tr(), LocaleKeys.get_sample_view_sample_3.tr(), LocaleKeys.get_sample_view_sample_4.tr(), LocaleKeys.get_sample_view_sample_5.tr(), LocaleKeys.get_sample_view_sample_6.tr(), LocaleKeys.get_sample_view_sample_7.tr(), LocaleKeys.get_sample_view_sample_8.tr(), LocaleKeys.get_sample_view_sample_9.tr(), LocaleKeys.get_sample_view_sample_10.tr() ]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height:40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 23.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // <-- Radius
                    ),
                  ),
                  onPressed: ()  {
                    Provider.of<PositionService>(context,listen: false).add(_titleController.text, _subtitleController.text);
                    setState(() {
                      lat = PositionService.lat!;
                      long = PositionService.long!;
                    });

                    Provider.of<DatabaseService>(context,listen: false).initDatabaseConnection(_titleController.text, _subtitleController.text, lat, long, file!.path, dropdownValue);
                    final snackBar = SnackBar(
                      content: Text('${_titleController.text} ${LocaleKeys.get_sample_view_title_5.tr()}'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Provider.of<NotificationService>(context, listen: false).sendPushMessage(_titleController.text, _subtitleController.text);


                  },
                  child: Text(LocaleKeys.get_sample_view_title_6.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}