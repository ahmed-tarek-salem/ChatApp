import 'dart:io';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:ChatApp/widgets/submit_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Upload extends StatefulWidget {
  File? file;
  Upload(this.file);
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  User? userUploadingPost;
  bool isUploading = false;
  TextEditingController locationController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  String postId = Uuid().v4();

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
        valueColor: AlwaysStoppedAnimation(Colors.purple),
      ),
    );
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String formattedPlace =
        ' ${placemark.country}, ${placemark.locality}, ${placemark.street}';
    locationController.text = formattedPlace;
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    //await compressImage();
    print('Oneeeeeeeeeeeeeeeeeeeeeeeeeeeee');
    String photoUrl =
        await databaseMethods.uploadImageToStorge(widget.file, postId);
    print('Is Goinnnnnnnnnnnnnnnnnnnnng');
    databaseMethods.createPostInFirestore(
        currentUserId: userUploadingPost!.uid,
        currentUsername: userUploadingPost!.username,
        description: captionController.text,
        location: locationController.text,
        mediaUrl: photoUrl,
        postId: postId,
        timeStamp: timeStamp);
    captionController.clear();
    locationController.clear();
    setState(() {
      //widget.file=null;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            isUploading ? linearProgress() : Text(""),
            Container(
              height: 300.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(widget.file!),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userUploadingPost!.photo!),
                radius: 35,
              ),
              title: TextField(
                controller: captionController,
                decoration: InputDecoration(
                    hintText: 'Write a caption', border: InputBorder.none),
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
                onPressed: () {
                  getUserLocation();
                },
                icon: Icon(
                  Icons.my_location,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                //if(isUploading)
                await handleSubmit();
                Navigator.pop(context);
              },
              child: SubmitButton('Upload Post'),
            ),
          ],
        ),
      ),
    );
  }
}
