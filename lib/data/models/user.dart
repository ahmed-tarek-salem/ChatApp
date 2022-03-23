import 'dart:core';

import 'package:ChatApp/data/models/user_spec.dart';

class User {
  String? uid;
  String? email;
  bool? state;
  UserSpec?
      userSpec; //Encapsulation .. UserSpecifications is better to be encapsulated seperately.

  User({this.uid, this.email, this.userSpec, this.state});

  factory User.fromDocument(doc) {
    return User(
      uid: doc['uid'],
      email: doc['email'],
      state: doc['state'],
      userSpec: UserSpec.fromDocument(doc),
    );
  }
}
