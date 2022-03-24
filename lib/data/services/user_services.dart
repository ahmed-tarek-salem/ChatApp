import 'package:ChatApp/data/models/user_spec.dart';
import 'package:ChatApp/view/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ChatApp/data/models/user.dart' as am;

class UserServices {
  setUserInfo(var userMap, var uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).set(userMap);
  }

  getUserInfo(String? uid) async {
    DocumentSnapshot doc = await refUsers.doc(uid).get();
    return am.User.fromDocument(doc);
  }

  Future<bool> updateUsersInfo(
      UserSpec updatedUser, String currentUserId) async {
    try {
      UserSpec userSpec = UserSpec(
          photo: updatedUser.photo,
          bio: updatedUser.bio,
          username: updatedUser.username);
      await refUsers.doc(currentUserId).update(userSpec.toDocument());
      print('User serv');

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<String>> getAllUsers(am.User currentUser) async {
    List<String> listOfUsers = [];
    try {
      QuerySnapshot querySnapshot =
          await refUsers.where('uid', isNotEqualTo: currentUser.uid).get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        listOfUsers.add(querySnapshot.docs[i]['username']);
      }
      return listOfUsers;
    } catch (e) {
      print(e);
      throw (e);
    }
  }
}
