import 'package:ChatApp/data/models/user.dart';
import 'package:ChatApp/view/screens/home_layout_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomServices {
  Future<List<User>>? getUsersRoomsList(String userId) async {
    List<User> usersRoomsList = [];
    QuerySnapshot querySnapshot =
        await refFollowing.doc(userId).collection('userFollowing').get();
    List<String> listOfFollowingDocs =
        querySnapshot.docs.map((e) => e.id).toList();
    for (String followingDoc in listOfFollowingDocs) {
      DocumentSnapshot documentSnapshot =
          await refUsers.doc(followingDoc).get();
      User user = User.fromDocument(documentSnapshot);
      usersRoomsList.add(user);
    }
    return usersRoomsList;
  }
}
