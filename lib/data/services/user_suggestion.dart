import 'package:ChatApp/data/models/user.dart';
import 'package:ChatApp/view/screens/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class UserSuggestion {
  final String currentUserId;
  UserSuggestion(this.currentUserId);
  Future<List<User?>> getUserSuggestions(String searchKey) async {
    List<User> _userSuggestions = [];
    try {
      QuerySnapshot querySnapshot = await refUsers
          .orderBy('username')
          .startAt([searchKey])
          .endAt([searchKey + '\uf8ff'])
          .limit(5)
          .get();
      //.where('username', isGreaterThanOrEqualTo: value).get();
      for (var doc in querySnapshot.docs) {
        User user = User.fromDocument(doc);
        if (user.uid != currentUserId) _userSuggestions.add(user);
      }
      return _userSuggestions;
    } catch (e) {
      print(e);
      return _userSuggestions;
    }
  }
}
