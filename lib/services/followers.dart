import 'package:cloud_firestore/cloud_firestore.dart';

class Followers {
  final CollectionReference refUsers =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference refFollowers =
      FirebaseFirestore.instance.collection('followers');
  final CollectionReference refFollowing =
      FirebaseFirestore.instance.collection('following');

  Future<bool> followFriend(String currentUserId, String friendId) async {
    try {
      await refFollowing
          .doc(currentUserId)
          .collection('userFollowing')
          .doc(friendId)
          .set({});
      await refFollowers
          .doc(friendId)
          .collection('userFollowers')
          .doc(currentUserId)
          .set({});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> unfollowFriend(String currentUserId, String friendId) async {
    try {
      await refFollowing
          .doc(currentUserId)
          .collection('userFollowing')
          .doc(friendId)
          .delete();
      await refFollowers
          .doc(friendId)
          .collection('userFollowers')
          .doc(currentUserId)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getStateFollowing(String currentUserId, String friendId) async {
    try {
      DocumentSnapshot documentSnapshot = await refFollowing
          .doc(currentUserId)
          .collection('userFollowing')
          .doc(friendId)
          .get();
      if (documentSnapshot.exists) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
