class Message{
  String message;
  String sentBy;
  bool isPhoto;
  var timeStamp;

  Message({this.message,this.timeStamp,this.isPhoto,this.sentBy});

  factory Message.fromDocument(doc){
    return Message(
      isPhoto: doc['isphoto'],
      message: doc['message'],
      sentBy: doc['sentby'],
    timeStamp: doc['timestamp']
    );
  }
}