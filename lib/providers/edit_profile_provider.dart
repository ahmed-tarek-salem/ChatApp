import 'dart:io';

import 'package:ChatApp/data/models/user.dart';
import 'package:ChatApp/data/models/user_spec.dart';
import 'package:ChatApp/data/services/storage_services.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// As you can expect from the name, this file is responsible for all the logic in the edit profile page.

class EditProfileProvider extends ChangeNotifier {
  // This provider relies heavily on the current user provider.
  User currentUser;
  EditProfileProvider(this.currentUser);
  File? file;
  bool isLoading = false;
  StorageServices storageServices = StorageServices();

  Future<void> handleSubmit(
      {required BuildContext context,
      required GlobalKey<FormState> formKey,
      required String bio,
      required String username}) async {
    if (formKey.currentState!.validate()) {
      setLoading(true);
      await updateProfile(bio, username, context);
      setLoading(false);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile Updated'),
        ),
      );
    }
  }

  Future<void> updateProfile(
      String bio, String username, BuildContext context) async {
    String photoUrl = file != null
        ? await storageServices.uploadImageToStorge(file, currentUser.uid!)
        : '';
    UserSpec? updatedUserSpec = UserSpec(
        bio: bio,
        photo: file == null ? currentUser.userSpec!.photo : photoUrl,
        username: username);
    Provider.of<UserProvider>(context, listen: false)
        .updateUserInfo(updatedUserSpec, currentUser.uid!);
  }

  void setLoading(bool state) {
    isLoading = state;
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Upload a photo'),
            children: [
              SimpleDialogOption(
                child: Text(
                  'Choose an image From Gallery',
                ),
                onPressed: () {
                  imageFromGallery(parentContext);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Open camera',
                ),
                onPressed: () {
                  imageFromCamera(parentContext);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

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
