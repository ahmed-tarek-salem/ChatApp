import 'package:ChatApp/data/models/user.dart';
import 'package:ChatApp/data/models/user_spec.dart';
import 'package:ChatApp/data/services/auth_services.dart';
import 'package:ChatApp/data/services/shared_pref.dart';
import 'package:ChatApp/data/services/user_services.dart';
import 'package:ChatApp/view/screens/home_page.dart';
import 'package:ChatApp/data/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  User? myUser;

  defineUser(String uid) async {
    await SharedPref().markTheUser(uid);
    DocumentSnapshot doc = await refUsers.doc(uid).get();
    User thisUser = User.fromDocument(doc);
    myUser = thisUser;
    notifyListeners();
    return thisUser;
  }

  updateUserInfo(UserSpec updatedUserSpec, String currentUserId) async {
    myUser?.userSpec!.bio = updatedUserSpec.bio;
    myUser?.userSpec!.photo = updatedUserSpec.photo;
    myUser?.userSpec!.username = updatedUserSpec.username;
    notifyListeners();
    print(' USer Provider');

    await UserServices().updateUsersInfo(updatedUserSpec, currentUserId);
  }

  logout() async {
    AuthServices authServices = AuthServices();
    await authServices.logOut(myUser!.uid);
    await SharedPref().removeMark();
  }
}
