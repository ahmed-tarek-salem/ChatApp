import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/screens/newsfeed.dart';
import 'package:ChatApp/screens/edit_profile.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/widgets/photo_with_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'home.dart';

final CollectionReference refUsers =
    FirebaseFirestore.instance.collection('users');
final CollectionReference refChats =
    FirebaseFirestore.instance.collection('chatrooms');
final CollectionReference refFeeds =
    FirebaseFirestore.instance.collection('feeds');
final CollectionReference refPosts =
    FirebaseFirestore.instance.collection('posts');
DatabaseMethods databaseMethods = DatabaseMethods();

String photoUrl;
User myCurrentUser;
final timeStamp = DateTime.now().millisecondsSinceEpoch;

class ChatRoom extends StatefulWidget {
  final String uid;
  final String urll;
  ChatRoom(this.uid, {this.urll});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  getUser() async {
    DocumentSnapshot doc = await refUsers.doc(widget.uid).get();
    myCurrentUser = User.fromDocument(doc);
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  int currentIndex = 0;
  String photoUrl;
  showPhotoIcon() async {
    DocumentSnapshot doc = await refUsers.doc(widget.uid).get();
    String url = doc['photo'];
    setStateIfMounted(() {
      photoUrl = url;
    });
  }

  @override
  void initState() {
    showPhotoIcon();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget returnPage(int index) {
      if (index == 0) {
        return Home();
      } else if (index == 1)
        return NewsFeed();
      else
        return EditProfile(widget.uid);
    }

    return photoUrl == null
        ? Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ))
        : Scaffold(
            body: photoUrl == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : returnPage(currentIndex),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: currentIndex,
              iconSize: 40,
              unselectedFontSize: 0,
              selectedItemColor: kGreenColor,
              unselectedIconTheme: IconThemeData(color: Color(0xff2E323B)),
              showSelectedLabels: false,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat_outlined), label: 'Home'),
                BottomNavigationBarItem(
                    icon: // Icon(Icons.message),
                        PhotoWithState(
                      colorOfBall: Colors.white,
                      photoUrl: photoUrl,
                      radiusOfBall: 0,
                      radius: 29,
                      state: true,
                    ),
                    // CircleAvatar(backgroundImage: CachedNetworkImageProvider(photoUrl), radius: 30,),
                    label: 'Home'),
              ],
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          );
  }

  // @override
  // void dispose() {
  //   showPhotoIcon();
  //   getUser();
  //   super.dispose();
  // }
}
