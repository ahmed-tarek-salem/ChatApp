import 'package:ChatApp/data/models/message.dart';
import 'package:ChatApp/data/models/user.dart';
import 'package:ChatApp/view/screens/home_page.dart';
import 'package:ChatApp/data/services/database.dart';
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
