import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:ChatApp/screens/welcome_screen.dart';
import 'package:ChatApp/services/shared_pref.dart';

import 'package:ChatApp/widgets/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  Stream<QuerySnapshot>? mySnapshot;
  int? chatCount = 0;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  getChatsCount() async {
    QuerySnapshot snapshot = await refUsers.get();
    void setStateIfMounted(f) {
      if (mounted) setState(f);
    }

    setStateIfMounted(() {
      chatCount = snapshot.docs.length - 1;
    });
  }

  @override
  void initState() {
    getChatsCount();
    super.initState();
  }

  //  Route<Object?> _dialogBuilder(
  //     BuildContext context, Object? arguments) {
  //   return DialogRoute<void>(
  //     context: context,
  //     builder: (BuildContext context) =>
  //         const AlertDialog(title: Text('Material Alert!')),
  //   );
  // @override
  // void dispose() {
  //   getChatsCount();
  //   super.dispose();
  // }
  //
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            Container(
              height: 13.5.h,
              child: Padding(
                padding: EdgeInsets.only(left: 12.5.w, right: 8.25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.8.h, horizontal: 2.25.w),
                          child: Text(
                            '$chatCount',
                            style: myGoogleFont(
                                Colors.white, 10.5.sp, FontWeight.w500),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15.0.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 3.25.w, right: 0.5.w),
                          child: Text(
                            'Chats',
                            style: myGoogleFont(
                                Colors.black, 13.8.sp, FontWeight.w500),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            color: kGreenColor,
                            size: 23.0.sp,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: _scaffoldKey.currentContext!,
                            builder: (context) {
                              return SimpleDialog(
                                title:
                                    Text("Are you sure you want to log out?"),
                                children: <Widget>[
                                  SimpleDialogOption(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await databaseMethods.logOut(
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .myUser
                                                ?.uid);
                                        await SharedPref().removeMark();
                                        Navigator.pushReplacement(
                                          _scaffoldKey.currentContext!,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return WelcomeScreen();
                                            },
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(color: Colors.red),
                                      )),
                                  SimpleDialogOption(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel')),
                                ],
                              );
                            });
                      },
                      icon: Icon(
                        Icons.exit_to_app_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: (1 / 6.7).h,
              width: double.infinity,
              color: Colors.grey[200],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0.w),
              child: TextField(
                onChanged: (val) async {
                  Stream<QuerySnapshot> snapshot = refUsers
                      .where('username',
                          isGreaterThanOrEqualTo: searchController.text)
                      .snapshots();
                  setState(() {
                    mySnapshot = snapshot;
                  });
                },
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: kGreenColor,
                      size: 22.0.sp,
                    ),
                    hintText: 'Search',
                    hintStyle:
                        myGoogleFont(Colors.black, 13.5.sp, FontWeight.w500),
                    // contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    // isDense: true,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: mySnapshot == null ? refUsers.snapshots() : mySnapshot,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  else {
                    chatCount = (snapshot.data!).docs.length;
                    return ListView.builder(
                        //reverse: true,
                        itemCount: (snapshot.data!).docs.length,
                        itemBuilder: (context, index) {
                          User friendUser =
                              User.fromDocument((snapshot.data!).docs[index]);
                          String myUserId =
                              Provider.of<UserProvider>(context, listen: false)
                                  .myUser!
                                  .uid!;
                          if (friendUser.uid != myUserId) {
                            return UserTile(friendUser);
                          } else
                            return Container();
                        });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
