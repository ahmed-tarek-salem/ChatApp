import 'package:ChatApp/message.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:ChatApp/services/database.dart';
import 'package:flutter/cupertino.dart';

class MessagesProvider extends ChangeNotifier {
  late Map<String, Message> lastMessages;
  int? numberOfUnseenMessages = 0;

  getNumberOfUnseenMessages(User friendUser, User currentUser) async {
    int? testCount =
        await databaseMethods.getCount(currentUser.email!, friendUser.email!);
    numberOfUnseenMessages = testCount;
    notifyListeners();
  }
}
