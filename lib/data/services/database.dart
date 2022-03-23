import 'dart:io';
import 'dart:math';

import 'package:ChatApp/data/models/message.dart';
import 'package:ChatApp/data/models/user_spec.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ChatApp/data/models/user.dart' as am;

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
  final CollectionReference refFollowers =
      FirebaseFirestore.instance.collection('followers');
  final CollectionReference refFollowing =
      FirebaseFirestore.instance.collection('following');

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

  returnNameOfChat(String name1, String name2) {
    int lengthOfSmallerEmail = [name1.length, name2.length].reduce(min);
    for (int i = 0; i < lengthOfSmallerEmail; i++) {
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

  Future<int?> getCount(String friendEmail, String currentUserEmail) async {
    try {
      int? myCount;
      String fullname = returnNameOfChat(friendEmail, currentUserEmail);
      DocumentSnapshot doc = await refChats
          .doc(fullname)
          .collection('unseenmessages')
          .doc(friendEmail)
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
      String friendEmail, String currentUserEmail) async {
    try {
      String fullname = returnNameOfChat(friendEmail, currentUserEmail);
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

  clearCount(String friendEmail, String currentUserEmail) async {
    try {
      String fullname = returnNameOfChat(friendEmail, currentUserEmail);
      await refChats
          .doc(fullname)
          .collection('unseenmessages')
          .doc(currentUserEmail)
          .set({'count': 0});
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
        'username': myUser.userSpec!.username,
        'photo': myUser.userSpec!.photo
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
}
