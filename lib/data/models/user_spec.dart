import 'dart:convert';

class UserSpec {
  String photo;
  String bio;
  String username;

  UserSpec({required this.photo, required this.bio, required this.username});

  Map<String, dynamic> toDocument() {
    return {
      'photo': photo,
      'bio': bio,
      'username': username,
    };
  }

  factory UserSpec.fromDocument(doc) {
    return UserSpec(
      photo: doc['photo'] ?? '',
      bio: doc['bio'] ?? '',
      username: doc['username'] ?? '',
    );
  }
}
