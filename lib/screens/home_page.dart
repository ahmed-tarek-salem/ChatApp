import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/providers/messages_provider.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/screens/newsfeed.dart';
import 'package:ChatApp/screens/edit_profile.dart';
import 'package:ChatApp/services/database.dart';
import 'package:ChatApp/services/shared_pref.dart';
import 'package:ChatApp/widgets/custom_progress_indicator.dart';
import 'package:ChatApp/widgets/photo_with_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'chat_rooms.dart';

final CollectionReference refUsers =
    FirebaseFirestore.instance.collection('users');
final CollectionReference refChats =
    FirebaseFirestore.instance.collection('chatrooms');
final CollectionReference refFeeds =
    FirebaseFirestore.instance.collection('feeds');
final CollectionReference refPosts =
    FirebaseFirestore.instance.collection('posts');
final CollectionReference refFollowers =
    FirebaseFirestore.instance.collection('followers');
final CollectionReference refFollowing =
    FirebaseFirestore.instance.collection('following');
DatabaseMethods databaseMethods = DatabaseMethods();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? uid;
  // getUser() async {
  //   DocumentSnapshot doc = await refUsers.doc(uid).get();
  //   myCurrentUser = User.fromDocument(doc);
  // }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  int currentIndex = 0;
  String? photoUrl;
  bool isLoading = true;

  retrieveData() async {
    final userAlreadyLoggedInId = await SharedPref().checkIfLoggedIn();
    if (userAlreadyLoggedInId != true) {
      await Provider.of<UserProvider>(context, listen: false)
          .defineUser(userAlreadyLoggedInId);
      print('Ok');
    }
  }

  @override
  void didChangeDependencies() async {
    await retrieveData();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    uid = userProvider.myUser?.uid;
    photoUrl = userProvider.myUser?.photo;
    // await userProvider.getLastMessages(userProvider.myUser!);
    setState(() {
      isLoading = false;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget returnPage(int index) {
      if (index == 0) {
        return ChatRooms(uid!);
      } else if (index == 1)
        return NewsFeed();
      else
        return EditProfile();
    }

    return Scaffold(
      body: isLoading == true
          ? CustomProgressIndicator()
          : returnPage(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: currentIndex,
        iconSize: 30.0.sp,
        unselectedFontSize: 0,
        selectedItemColor: kGreenColor,
        unselectedIconTheme: IconThemeData(color: Color(0xff2E323B)),
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(left: 2.w),
                child: Icon(
                  Icons.search,
                  size: 30.0.sp,
                ),
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon:
                  // Icon(Icons.message),
                  photoUrl == null
                      ? Container(
                          child: CustomProgressIndicator(),
                        )
                      : PhotoWithState(
                          colorOfBall: Colors.white,
                          photoUrl:
                              Provider.of<UserProvider>(context).myUser?.photo,
                          radiusOfBall: 0,
                          radius: 7.5.h,
                          state: true,
                        ),
              //     CircleAvatar(
              //   backgroundImage: CachedNetworkImageProvider(photoUrl),
              //   radius: 30,
              // ),
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
