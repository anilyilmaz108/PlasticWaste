import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plastic/extensions/locale_keys.dart';

class ImageService extends ChangeNotifier{

  static File? file;

  uploadImageFromGallery() async {
    final _imagePicker = ImagePicker();
    PickedFile? image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image

      image = await _imagePicker.getImage(source: ImageSource.gallery);
      file = File(image!.path);


    } else {
      print('Permission not granted. Try Again with permission access');
      notifyListeners();
    }
  }

  uploadImageFromCamera() async {
    final _imagePicker = ImagePicker();
    PickedFile? image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = await _imagePicker.getImage(source: ImageSource.camera);
      file = File(image!.path);

    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  Future<void> showImageDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.image_service_title_1.tr(),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(LocaleKeys.image_service_title_2.tr(),),
                Text(LocaleKeys.image_service_title_3.tr(),),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(LocaleKeys.image_service_title_4.tr(),),
              onPressed: () {
                //GetSampleHelper.uploadImageFromGallery(GetSampleHelper.file);
                uploadImageFromGallery();
                Navigator.of(context).pop();
                notifyListeners();
              },
            ),
            TextButton(
              child: Text(LocaleKeys.image_service_title_5.tr(),),
              onPressed: () {
                uploadImageFromCamera();
                Navigator.of(context).pop();
                notifyListeners();
              },
            ),
            file == null
                ? TextButton(
                child: Text(LocaleKeys.image_service_title_6.tr(),),
                onPressed: null
            )
                : TextButton(
              child: Text(LocaleKeys.image_service_title_6.tr(),),
              onPressed: () {
                file = null;
                notifyListeners();
              },
            ),
          ],
        );
      },
    );
  }
}