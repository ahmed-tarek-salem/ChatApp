import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/screens/chat_room.dart';
import 'package:ChatApp/screens/welcome_screen.dart';
import 'package:ChatApp/services/shared_pref.dart';
import 'package:ChatApp/widgets/user_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<QuerySnapshot> mySnapshot;
  int chatCount = 0;
  TextEditingController searchController = TextEditingController();

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

  // @override
  // void dispose() {
  //   getChatsCount();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                        child: Text(
                          '$chatCount',
                          style:
                              myGoogleFont(Colors.white, 14, FontWeight.w500),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0, right: 2),
                        child: Text(
                          'Chats',
                          style:
                              myGoogleFont(Colors.black, 18, FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: kGreenColor,
                          size: 30,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: Text("Are you sure you want to log out?"),
                              children: <Widget>[
                                SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      databaseMethods.logOut(myCurrentUser.uid);
                                      SharedPref().removeMark();
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) {
                                        return WelcomeScreen();
                                      }));
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
            height: 1,
            width: double.infinity,
            color: Colors.grey[200],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
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
                    size: 30,
                  ),
                  hintText: 'Search',
                  hintStyle: myGoogleFont(Colors.black, 18, FontWeight.w500),
                  // contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  // isDense: true,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: mySnapshot == null ? refUsers.snapshots() : mySnapshot,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                else {
                  chatCount = snapshot.data.docs.length;
                  return ListView.builder(
                      //reverse: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        User myUser =
                            User.fromDocument(snapshot.data.docs[index]);
                        if (myUser.uid != myCurrentUser.uid)
                          return UserTile(myUser);
                        else
                          return Container();
                      });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
