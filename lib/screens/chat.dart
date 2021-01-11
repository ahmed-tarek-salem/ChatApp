import 'dart:io';
import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/screens/chat_room.dart';
import 'package:ChatApp/screens/user_profile.dart';
import 'package:ChatApp/widgets/message_tile.dart';
import 'package:ChatApp/widgets/photo_with_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Chat extends StatefulWidget {
  final User messageUser;
  final Function myFunc;
  Chat(this.messageUser, {this.myFunc});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController messageController = TextEditingController();
  final timeStamp = DateTime.now();
  File file;
  bool isLoading;
  int counter;
  String imageMessageId = Uuid().v4();

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
      file = File(pickedFile.path);
    });
    submitImage();
  }

  imageFromCamera(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setStateIfMounted(() {
      file = File(pickedFile.path);
    });
    submitImage();
  }

  submitImage() async {
    setStateIfMounted(() {
      isLoading = true;
    });
    String photoUrl =
        await databaseMethods.uploadImageToStorge(file, imageMessageId);
    await databaseMethods.sendMessage(widget.messageUser.username,
        myCurrentUser.username, photoUrl, myCurrentUser.uid, true, counter);
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
    await databaseMethods.sendMessage(
        widget.messageUser.username,
        myCurrentUser.username,
        messageController.text,
        myCurrentUser.uid,
        false,
        counter);
    messageController.clear();
    counterHandle();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  counterHandle() async {
    int counttest = await databaseMethods.getCount(
        widget.messageUser.username, myCurrentUser.username);
    setStateIfMounted(() {
      counter = counttest;
    });
  }

  clearCount() async {
    await databaseMethods.clearCount(
        widget.messageUser.username, myCurrentUser.username);
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
  void initState() {
    counterHandle();
    clearCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              // height: 120,
              padding:
                  EdgeInsets.only(right: 15, left: 20, top: 40, bottom: 20),
              child: ListTile(
                  leading: Hero(
                    tag: 'ProfilePhoto',
                    child: PhotoWithState(
                        state: widget.messageUser.state,
                        photoUrl: widget.messageUser.photo,
                        radius: 30,
                        radiusOfBall: 7,
                        colorOfBall: Colors.white),
                  ),
                  title: Text(
                    widget.messageUser.username,
                    style: myGoogleFont(Colors.black, 18, FontWeight.w500),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      color: kGreenColor,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return UserProfile(widget.messageUser);
                      }));
                    },
                  )),
            ),
            Container(
                width: double.infinity, height: .5, color: Colors.grey[300]),
            Expanded(
              child: StreamBuilder(
                stream: refChats
                    .doc(databaseMethods.returnName(
                        widget.messageUser.username, myCurrentUser.username))
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
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          String sender = snapshot.data.docs[index]['sentby'];
                          User messageSender;
                          if (sender == myCurrentUser.uid)
                            messageSender = myCurrentUser;
                          else
                            messageSender = widget.messageUser;
                          return MessageTile(
                            message: snapshot.data.docs[index]['message'],
                            messageSender: messageSender,
                            isPhoto: snapshot.data.docs[index]['isphoto'],
                            timeStamp: DateTime.fromMillisecondsSinceEpoch(
                                snapshot.data.docs[index]['timestamp']),
                          );
                        });
                  }
                },
              ),
            ),
            Container(
                width: double.infinity, height: .5, color: Colors.grey[300]),
            Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 39),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: messageController,
                        style: myGoogleFont(Colors.black, 18, FontWeight.w500),
                        decoration: InputDecoration(
                            hintText: 'Your message',
                            hintStyle:
                                myGoogleFont(Colors.black, 18, FontWeight.w500),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          submitMessage();
                        },
                        child: Icon(Icons.send_rounded)),
                    SizedBox(width: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[300]),
                      // height: 40,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              child: Icon(Icons.add_photo_alternate_outlined,
                                  size: 25),
                              onTap: () {
                                selectImage(context);
                              },
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              child: Icon(Icons.my_location, size: 25),
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
      ),
    );
  }
}
