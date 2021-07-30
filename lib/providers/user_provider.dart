import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:ChatApp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  User? myUser;

  defineUser(String uid) async {
    print('Start');

    CollectionReference refUsers =
        FirebaseFirestore.instance.collection('users');
    DocumentSnapshot doc = await refUsers.doc(uid).get();
    User thisUser = User.fromDocument(doc);
    myUser = thisUser;
    notifyListeners();
    print('Done');
    return thisUser;
  }

  updateUserInfo(User updatedUser, String currentUserId) async {
    myUser?.bio = updatedUser.bio;
    myUser?.photo = updatedUser.photo;
    myUser?.username = updatedUser.username;
    notifyListeners();
    await DatabaseMethods().upDateUsersInfo(updatedUser, currentUserId);
  }

  // getLastMessages(User currentUser) async {
  //   List<String> allUsersNames = await databaseMethods.allUsers(currentUser);
  //   List<String> allChatsNames = [];
  //   for (int i = 0; i < allUsersNames.length; i++) {
  //     String nameOfChat = await databaseMethods.returnNameOfChat(
  //         currentUser.username!, allUsersNames[i]);
  //     allChatsNames.add(nameOfChat);
  //   }
  //   databaseMethods.listOfLastMessages(allChatsNames);
  // }
}
