import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  String ownerId;
  String postId;
  String location;
  var timeStamp;
  String username;
  String des;
  String mediaUrl;
  int likesCount;
  

  Post({
    this.ownerId,
    this.postId,
    this.location,
    this.des,
    this.mediaUrl,
    this.timeStamp,
    this.username,
  });

  factory Post.fromDocument(DocumentSnapshot doc){
   return Post(
      ownerId: doc['ownerId'],
      postId: doc['postId'],
      timeStamp: doc['timestamp'],
      mediaUrl: doc['mediaUrl'],
      location: doc['location'],
      des: doc['description'],
      username: doc['username'],
    );
  }

} 