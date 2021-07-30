import 'dart:io';
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

  getUserInfo(String? uid) async {
    DocumentSnapshot doc = await refUsers.doc(uid).get();
    return am.User.fromDocument(doc);
  }

  Future<String> uploadImageToStorge(File? imageFile, String imageId) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('image_$imageId');
    TaskSnapshot taskSnapshot = await ref.putFile(imageFile!);
    return await taskSnapshot.ref.getDownloadURL();
    //الفرق بين uploadTask و TaskSnapshot ال await
  }

  upDateUsersInfo(am.User updatedUser, String currentUserId) {
    try {
      refUsers.doc(currentUserId).update(
        {
          'photo': updatedUser.photo,
          'bio': updatedUser.bio,
          'username': updatedUser.username
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> allUsers(am.User currentUser) async {
    List<String> listOfUsers = [];
    try {
      QuerySnapshot querySnapshot =
          await refUsers.where('uid', isNotEqualTo: currentUser.uid).get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        listOfUsers.add(querySnapshot.docs[i]['username']);
      }
      print(listOfUsers);
      return listOfUsers;
    } catch (e) {
      print(e);
      throw (e);
    }
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
      String? myCurrentUserUid, bool isPhoto, int counter) async {
    String fullname = returnNameOfChat(userMessageName, myCurrentUserName);
    await refChats.doc(fullname).collection('chatmessages').add({
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'sentby': myCurrentUserUid,
      'isphoto': isPhoto,
    });
    //send message to counter unseen messages
    await increaseCount(counter, userMessageName, myCurrentUserName);

    //send message to last messages collection
    await refChats
        .doc(fullname)
        .collection('unseenmessages')
        .doc('lastmessage')
        .set({
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'sentby': myCurrentUserUid,
      'isphoto': isPhoto,
    });
  }

  returnNameOfChat(String name1, String name2) {
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

  // listOfLastMessages(List<String> chatNames) async {
  //   Map<String, String> mapOfChatNamesAndLastMessages = {};
  //   for (int i = 0; i < chatNames.length; i++) {
  //     DocumentSnapshot documentSnapshot = await refChats
  //         .doc(chatNames[i])
  //         .collection('unseenmessages')
  //         .doc('lastmessage')
  //         .get();
  //     String lastMessage = documentSnapshot['message'];
  //     mapOfChatNamesAndLastMessages.putIfAbsent(
  //         chatNames[i], () => lastMessage);
  //   }
  //   print(mapOfChatNamesAndLastMessages);
  // }

  increaseCount(
      int count, String userMessageName, String myCurrentUserName) async {
    String fullname = returnNameOfChat(userMessageName, myCurrentUserName);
    await refChats
        .doc(fullname)
        .collection('unseenmessages')
        .doc(userMessageName)
        .set({'count': count + 1});
  }

  Future<int?> getCount(
      String userMessageName, String myCurrentUserName) async {
    try {
      int? myCount;
      String fullname = returnNameOfChat(userMessageName, myCurrentUserName);
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
    } catch (e) {
      print(e);
    }
  }

  Future<Message?> getLastMessage(
      String userMessageName, String myCurrentUserName) async {
    try {
      String fullname = returnNameOfChat(userMessageName, myCurrentUserName);
      DocumentSnapshot doc = await refChats
          .doc(fullname)
          .collection('unseenmessages')
          .doc('lastmessage')
          .get();
      if (doc.exists) {
        Message myMessage = Message.fromDocument(doc);
        return myMessage;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  clearCount(String userMessageName, String myCurrentUserName) async {
    try {
      String fullname = returnNameOfChat(userMessageName, myCurrentUserName);
      await refChats
          .doc(fullname)
          .collection('unseenmessages')
          .doc(myCurrentUserName)
          .set({'count': 0});
    } catch (e) {
      print(e);
    }
  }

  logOut(String? uid) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      await refUsers.doc(uid).update({'state': false});
      await _auth.signOut();
      print('Logged out');
    } catch (e) {
      print(e);
    }
  }

  addToNewsFeed(String idOfNotifier) async {
    try {
      DocumentSnapshot doc = await refUsers.doc(idOfNotifier).get();
      am.User myUser = am.User.fromDocument(doc);
      await refFeeds.doc(idOfNotifier).set({
        'timestamp': DateTime.now(),
        'type': 'update',
        'username': myUser.username,
        'photo': myUser.photo
      });
    } catch (e) {
      print(e);
    }
  }

  createPostInFirestore(
      {String? mediaUrl,
      String? location,
      String? description,
      String? currentUserId,
      String? currentUsername,
      var timeStamp,
      String? postId}) async {
    try {
      await refPosts.doc(postId).set({
        "postId": postId,
        "ownerId": currentUserId,
        "username": currentUsername,
        "mediaUrl": mediaUrl,
        "description": description,
        "location": location,
        "timestamp": timeStamp,
      });
    } catch (e) {
      print(e);
    }
  }

  //we stopped here
}
