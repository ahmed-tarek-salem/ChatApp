import 'dart:io';

import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:ChatApp/screens/user_profile.dart';
import 'package:ChatApp/widgets/message_tile.dart';
import 'package:ChatApp/widgets/photo_with_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sizer/sizer.dart';

class SingleChatRoom extends StatefulWidget {
  final User messageUser;

  final Function? myFunc;
  SingleChatRoom(this.messageUser, {this.myFunc});
  @override
  _SingleChatRoomState createState() => _SingleChatRoomState();
}

class _SingleChatRoomState extends State<SingleChatRoom> {
  TextEditingController messageController = TextEditingController();
  final timeStamp = DateTime.now();
  late File file;
  bool? isLoading;
  int? counter;
  String imageMessageId = Uuid().v4();
  User? myCurrentUser;
  bool isFirstTime = true;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  imageFromGallery(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 85);
    setStateIfMounted(() {
      file = File(pickedFile!.path);
    });
    submitImage();
  }

  imageFromCamera(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setStateIfMounted(() {
      file = File(pickedFile!.path);
    });
    submitImage();
  }

  submitImage() async {
    setStateIfMounted(() {
      isLoading = true;
    });
    String photoUrl =
        await databaseMethods.uploadImageToStorge(file, imageMessageId);
    await databaseMethods.sendMessage(widget.messageUser.username!,
        myCurrentUser!.username!, photoUrl, myCurrentUser!.uid, true, counter!);
    setStateIfMounted(() {
      // file=null;
      isLoading = false;
    });
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

  submitMessage() async {
    String message = messageController.text;
    messageController.clear();
    await databaseMethods.sendMessage(widget.messageUser.username!,
        myCurrentUser!.username!, message, myCurrentUser!.uid, false, counter!);

    counterHandle();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  counterHandle() async {
    int? counttest = await databaseMethods.getCount(
        widget.messageUser.username!, myCurrentUser!.username!);
    setStateIfMounted(() {
      counter = counttest;
    });
  }

  clearCount() async {
    await databaseMethods.clearCount(
        widget.messageUser.username!, myCurrentUser!.username!);
  }

  getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String formattedPlace = '${placemark.locality} , ${placemark.country}';
    messageController.text = formattedPlace;
  }

  @override
  void didChangeDependencies() {
    if (isFirstTime) {
      myCurrentUser = Provider.of<UserProvider>(context, listen: false).myUser;
      counterHandle();
      clearCount();
      isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  // onWillPop: () {
  //    Navigator.pop(context, true);
  // } as Future<bool> Function()?,
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UserProfile(widget.messageUser);
              }));
            },
            child: Container(
              // height: 120,
              padding: EdgeInsets.only(
                  right: 3.75.w, left: 5.0.w, top: 6.0.h, bottom: 2.5.h),
              child: ListTile(
                leading: Hero(
                  tag: 'ProfilePhoto',
                  child: PhotoWithState(
                      state: widget.messageUser.state,
                      photoUrl: widget.messageUser.photo,
                      radius: 8.5.h,
                      radiusOfBall: 7,
                      colorOfBall: Colors.white),
                ),
                title: Text(
                  widget.messageUser.username!,
                  style: myGoogleFont(Colors.black, 14.0.sp, FontWeight.w500),
                ),
                trailing: GestureDetector(
                  child: Icon(
                    Icons.more_horiz,
                    color: kGreenColor,
                    size: 23.0.sp,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UserProfile(widget.messageUser);
                    }));
                  },
                ),
              ),
            ),
          ),
          Container(
              width: double.infinity, height: .25.h, color: Colors.grey[300]),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: refChats
                  .doc(databaseMethods.returnNameOfChat(
                      widget.messageUser.username!, myCurrentUser!.username!))
                  .collection('chatmessages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                      reverse: true,
                      itemCount: (snapshot.data!).docs.length,
                      itemBuilder: (context, index) {
                        String? sender = snapshot.data?.docs[index]['sentby'];
                        User? messageSender;
                        if (sender == myCurrentUser!.uid)
                          messageSender = myCurrentUser;
                        else
                          messageSender = widget.messageUser;
                        return MessageTile(
                          message: snapshot.data?.docs[index]['message'],
                          messageSender: messageSender,
                          isPhoto: snapshot.data?.docs[index]['isphoto'],
                          timeStamp: DateTime.fromMillisecondsSinceEpoch(
                              snapshot.data?.docs[index]['timestamp']),
                        );
                      });
                }
              },
            ),
          ),
          Container(
              width: double.infinity, height: .5, color: Colors.grey[300]),
          Container(
              padding:
                  EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 9.75.w),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: messageController,
                      style:
                          myGoogleFont(Colors.black, 14.0.sp, FontWeight.w500),
                      decoration: InputDecoration(
                          hintText: 'Your message',
                          hintStyle: myGoogleFont(
                              Colors.black, 14.0.sp, FontWeight.w500),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        submitMessage();
                      },
                      child: Icon(Icons.send_rounded)),
                  SizedBox(width: 2.5.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 1.4.h, horizontal: 3.75.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0.sp),
                        color: Colors.grey[300]),
                    // height: 40,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Icon(Icons.add_photo_alternate_outlined,
                                size: 19.2.sp),
                            onTap: () {
                              selectImage(context);
                            },
                          ),
                          SizedBox(width: 2.4.w),
                          GestureDetector(
                            child: Icon(Icons.my_location, size: 19.2.sp),
                            //location pin
                            onTap: () {
                              getUserLocation();
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
