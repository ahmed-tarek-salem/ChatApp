import 'dart:io';
import 'package:ChatApp/constants.dart';
import 'package:ChatApp/data/models/user.dart';
import 'package:ChatApp/data/services/storage_services.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/view/screens/home_page.dart';
import 'package:ChatApp/view/widgets/custom_progress_indicator.dart';
import 'package:ChatApp/view/widgets/submit_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UploadingScreen extends StatefulWidget {
  File? file;
  UploadingScreen(this.file);
  @override
  _UploadingScreenState createState() => _UploadingScreenState();
}

class _UploadingScreenState extends State<UploadingScreen> {
  User? userUploadingPost;
  bool isUploading = false;
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  String postId = Uuid().v4();
  StorageServices storageServices = StorageServices();

  @override
  void initState() {
    userUploadingPost =
        Provider.of<UserProvider>(context, listen: false).myUser;
    super.initState();
  }

  @override
  void dispose() {
    locationController.dispose();
    captionController.dispose();
    super.dispose();
  }

  Container linearProgress() {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(kGreenColor),
        backgroundColor: Colors.grey[300],
      ),
    );
  }

  getCurrentLocation() async {
    String formatedPlace = await getCurrentLocation();
    locationController.text = formatedPlace;
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    String photoUrl =
        await storageServices.uploadImageToStorge(widget.file, postId);
    databaseMethods.createPostInFirestore(
        currentUserId: userUploadingPost!.uid,
        currentUsername: userUploadingPost!.userSpec!.username,
        description: captionController.text,
        location: locationController.text,
        mediaUrl: photoUrl,
        postId: postId,
        timeStamp: DateTime.now().millisecondsSinceEpoch);
    captionController.clear();
    locationController.clear();
    setState(() {
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: isUploading
              ? CustomProgressIndicator()
              : ListView(
                  children: [
                    Container(
                      height: 250.0,
                      width: double.infinity,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: FileImage(widget.file!),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(userUploadingPost!.userSpec!.photo),
                        radius: 35,
                      ),
                      title: TextField(
                        controller: captionController,
                        decoration: InputDecoration(
                            hintText: 'Write a caption',
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Icon(
                          Icons.pin_drop,
                          color: Colors.orange,
                          size: 45.0,
                        ),
                      ),
                      title: Container(
                        width: 250.0,
                        child: TextField(
                          controller: locationController,
                          decoration: InputDecoration(
                            hintText: "Where was this photo taken?",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 200.0,
                      height: 100.0,
                      alignment: Alignment.center,
                      child: RaisedButton.icon(
                        label: Text(
                          "Use Current Location",
                          style: TextStyle(color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Colors.grey[500],
                        onPressed: getCurrentLocation,
                        icon: Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await handleSubmit();
                        Navigator.pop(context);
                      },
                      child: SubmitButton('Upload Post'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
