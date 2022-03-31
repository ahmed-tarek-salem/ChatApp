import 'package:ChatApp/data/models/message.dart';
import 'package:ChatApp/view/screens/home_layout_screen.dart';

import '../../constants.dart';

class MessageServices {
  Future<void> sendMessage(
      String friendEmail,
      String currentUserEmail,
      String messageText,
      String? myCurrentUserUid,
      bool isPhoto,
      int counter) async {
    Message message = Message(
        message: messageText,
        isPhoto: isPhoto,
        sentBy: currentUserEmail,
        timeStamp: DateTime.now().millisecondsSinceEpoch);
    String fullname = returnNameOfChat(friendEmail, currentUserEmail);
    await refChats
        .doc(fullname)
        .collection('chatmessages')
        .add(Message.toDocument(message));
    //send message to counter unseen messages
    await increaseCount(counter, friendEmail, currentUserEmail);

    //send message to last messages collection
    await refChats
        .doc(fullname)
        .collection('unseenmessages')
        .doc('lastmessage')
        .set(Message.toDocument(message));
  }

  increaseCount(int count, String friendEmail, String currentUserEmail) async {
    String fullname = returnNameOfChat(friendEmail, currentUserEmail);
    await refChats
        .doc(fullname)
        .collection('unseenmessages')
        .doc(friendEmail)
        .set({'count': count + 1});
  }
}
