import 'dart:io';

import 'package:ChatApp/data/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileProvider extends ChangeNotifier {
  User currentUser;
  EditProfileProvider(this.currentUser);
  File? file;
  bool isLoading = true;

  imageFromGallery(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) file = File(pickedFile.path);
    notifyListeners();
  }

  imageFromCamera(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 70);
    if (pickedFile != null) file = File(pickedFile.path);
    notifyListeners();
  }
}
