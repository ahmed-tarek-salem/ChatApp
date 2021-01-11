import 'dart:math';

import 'package:ChatApp/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ChatApp/models/user.dart' as am;

class DatabaseMethods {
  var url;
  final CollectionReference refUsers =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference refChats =
      FirebaseFirestore.instance.collection('chatrooms');
  final CollectionReference refFeeds =
      FirebaseFirestore.instance.collection('feeds');
  final CollectionReference refPosts =
      FirebaseFirestore.instance.collection('posts');

  setUserInfo(var userMap, var uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).set(userMap);
  }

  Future<String> uploadImageToStorge(imageFile, userId) async {
    StorageReference firebaseStorageRef =
        // FirebaseStorage.instance.ref().child('uploads/$fileName');
        FirebaseStorage.instance.ref().child('image_$userId');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String photoUrl = await taskSnapshot.ref.getDownloadURL();
    return photoUrl;
  }

  upDateUsersInfo(userId, url, String myBio, String myUsername) {
    refUsers
        .doc(userId)
        .update({'photo': url, 'bio': myBio, 'username': myUsername});
  }

  //setPhotoToFirebase(String uid, var url){
  /* return FirebaseFirestore.instance.collection('users').where(
      'email', isEqualTo: email
    ).get(); */
  /* return FirebaseFirestore.instance.collection('images').doc(uid).set({
      'Image': url
    });
  } */

  getPhotoFromFirebase(String uid) async {
    DocumentSnapshot doc = await refUsers.doc(uid).get();
    return doc['photo'];
  }

  getBioFromFirebase(String uid) async {
    DocumentSnapshot doc = await refUsers.doc(uid).get();
    return doc['bio'];
  }

  getUsernameFromFirebase(String uid) async {
    DocumentSnapshot doc = await refUsers.doc(uid).get();
    return doc['username'];
  }

  sendMessage(String userMessageName, String myCurrentUserName, String message,
      String myCurrentUserUid, bool isPhoto, int counter) async {
    String fullname = returnName(userMessageName, myCurrentUserName);
    await refChats.doc(fullname).collection('chatmessages').add({
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'sentby': myCurrentUserUid,
      'isphoto': isPhoto,
    });
    //send message to counter unseen messages
    await increaseCount(counter, userMessageName, myCurrentUserName);

    //send message to last messages collection
    await refChats.doc(fullname).collection('unseenmessages').doc('lastmessage')
    .set({
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'sentby': myCurrentUserUid,
      'isphoto': isPhoto,
    });
  }

 

  returnName(String name1, String name2) {
    int numberr = [name1.length, name2.length].reduce(min);
    for (int i = 0; i < numberr; i++) {
      if (name1[i].codeUnitAt(0) < name2[i].codeUnitAt(0)) {
        return '$name1 _ $name2'.trim();
      } else if (name1[i].codeUnitAt(0) > name2[i].codeUnitAt(0)) {
        return '$name2 _ $name1'.trim();
      }
    }
    return '$name1 _ $name2'.trim();
  }

  increaseCount(
      int count, String userMessageName, String myCurrentUserName) async {
    String fullname = returnName(userMessageName, myCurrentUserName);
    await refChats
        .doc(fullname)
        .collection('unseenmessages')
        .doc(userMessageName)
        .set({'count': count + 1});
  }

  Future<int> getCount(String userMessageName, String myCurrentUserName) async {
    int myCount;
    String fullname = returnName(userMessageName, myCurrentUserName);
    DocumentSnapshot doc = await refChats
        .doc(fullname)
        .collection('unseenmessages')
        .doc(userMessageName)
        .get();
    if (doc.exists) {
      myCount = doc['count'];
    } else {
      myCount = 0;
    }
    return myCount;
  }

  Future<Message> getLastMessage(String userMessageName, String myCurrentUserName)
  async{
    String fullname = returnName(userMessageName, myCurrentUserName);
    DocumentSnapshot doc= await refChats.doc(fullname)
    .collection('unseenmessages')
    .doc('lastmessage')
    .get();
    if(doc.exists){
      Message myMessage =Message.fromDocument(doc);
      return myMessage;
    }
    else{
      return null;
    }


  }

  clearCount(String userMessageName, String myCurrentUserName) async {
    String fullname = returnName(userMessageName, myCurrentUserName);
    await refChats
        .doc(fullname)
        .collection('unseenmessages')
        .doc(myCurrentUserName)
        .set({'count': 0});
  }

  logOut(String uid) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await refUsers.doc(uid).update({'state': false});
    await _auth.signOut();
  }

  addToNewsFeed(String idOfNotifier) async {
    DocumentSnapshot doc = await refUsers.doc(idOfNotifier).get();
    am.User myUser = am.User.fromDocument(doc);
    await refFeeds.doc(idOfNotifier).set({
      'timestamp': DateTime.now(),
      'type': 'update',
      'username': myUser.username,
      'photo': myUser.photo
    });
  }

  createPostInFirestore(
      {String mediaUrl,
      String location,
      String description,
      String currentUserId,
      String currentUsername,
      var timeStamp,
      String postId}) async {
    await refPosts.doc(postId).set({
      "postId": postId,
      "ownerId": currentUserId,
      "username": currentUsername,
      "mediaUrl": mediaUrl,
      "description": description,
      "location": location,
      "timestamp": timeStamp,
    });
  }

  //we stopped here
}
