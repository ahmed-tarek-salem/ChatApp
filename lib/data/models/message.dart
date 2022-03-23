import 'package:flutter/cupertino.dart';

class Message {
  late String message;
  String? sentBy;
  bool? isPhoto;
  var timeStamp;

  Message({required this.message, this.timeStamp, this.isPhoto, this.sentBy});

  factory Message.fromDocument(doc) {
    return Message(
      isPhoto: doc['isPhoto'],
      message: doc['message'],
      sentBy: doc['sentby'],
      timeStamp: doc['timeStamp'],
    );
  }

  static Map<String, dynamic> toDocument(Message message) {
    return {
      'isPhoto': message.isPhoto,
      'message': message.message,
      'sentBy': message.sentBy,
      'timeStamp': message.timeStamp,
    };
  }
}
