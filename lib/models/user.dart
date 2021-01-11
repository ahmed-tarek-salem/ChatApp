import 'dart:core';
class User{

  String uid;
  String username;
  String bio;
  String email;
  String photo;
  bool state;

  User({
    this.uid,
    this.bio,
    this.email,
    this.username,
    this.photo,
    this.state
  });

  factory User.fromDocument(doc){
    return User(
      uid: doc['uid'],
      bio: doc['bio'],
      email: doc['email'],
      username: doc['username'],
      photo: doc['photo'],
      state: doc['state']
    );
  }
}