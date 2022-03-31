import 'package:ChatApp/constants.dart';
import 'package:ChatApp/providers/home_layout_provider.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/view/screens/newsfeed.dart';
import 'package:ChatApp/view/screens/edit_profile.dart';
import 'package:ChatApp/data/services/database.dart';
import 'package:ChatApp/view/widgets/custom_progress_indicator.dart';
import 'package:ChatApp/view/widgets/photo_with_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'chat_rooms.dart';

// This is the layout of the application. when a user logs in this is the first screen he should see.
// The layout consists of two parts, a changing part, and a fixed part.
// The fixed part is the Scaffold page which contains a bottom navigation bar.
// The second part depends on the index comes from the bottom navigation bar, it can be:
// 1- Chat rooms screen, which contains all the chats of the users you have followed.
// 2- Newsfeed screen, which contains all the posts from the users you have followed.
// 3- Edit profile screen, from which the user can change and update his information.
// As we writing in MVVM, each screen should have its "View model" to handle the data of widgets, view models

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

class HomeLayoutScreen extends StatefulWidget {
  @override
  _HomeLayoutScreenState createState() => _HomeLayoutScreenState();
}

class _HomeLayoutScreenState extends State<HomeLayoutScreen> {
  retrieveUsersData() async {
    Provider.of<HomeLayoutProvider>(context, listen: false)
        .retrieveUsersData(context);
  }

  @override
  void initState() {
    super.initState();
    retrieveUsersData();
  }

  //Here is the function that cares about the "changing part" of this screen.
  Widget returnPage(int index) {
    if (index == 0) {
      return ChatRooms();
    } else if (index == 1)
      return NewsFeed();
    else
      return EditProfile();
  }

  @override
  Widget build(BuildContext context) {
    //A consumer of HomeLayoutProvider to handle the data of this screen. eg: loading.
    return Consumer<HomeLayoutProvider>(
        builder: (context, homeLayoutProvider, child) {
      return Scaffold(
        body: homeLayoutProvider.isLoading == true
            ? CustomProgressIndicator()
            : returnPage(homeLayoutProvider.currentIndex),
        //A consumer of UserProvider just to retrieve the photo of the current user which appears on the
        //bottom navigation bar.
        bottomNavigationBar:
            Consumer<UserProvider>(builder: (context, userProvider, _) {
          return BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: homeLayoutProvider.currentIndex,
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
                  icon: userProvider.myUser?.userSpec!.photo != null
                      ? PhotoWithState(
                          radiusOfBall: 0,
                          radius: 7.5.h,
                          state: true,
                          colorOfBall: Colors.white,
                          photoUrl: userProvider.myUser?.userSpec!.photo)
                      : Container(),
                  label: 'Home'),
            ],
            // note that the two functions (onTap, setCurrentIndex) take the same parameter (index), so you can
            // call the function like this.
            //
            onTap: homeLayoutProvider.setCurrentIndex,
          );
        }),
      );
    });
  }
}
