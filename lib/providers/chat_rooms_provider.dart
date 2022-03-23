import 'package:ChatApp/data/models/user.dart';
import 'package:ChatApp/data/services/chatrooms_services.dart';
import 'package:flutter/cupertino.dart';

class ChatRoomsProvider extends ChangeNotifier {
  List<User>? userRoomsList = [];
  bool isLoading = true;
  ChatRoomServices _chatRoomServices = ChatRoomServices();

  getUserRoomsList(String currentUserId) async {
    setLoading(true);
    userRoomsList = await _chatRoomServices.getUsersRoomsList(currentUserId);
    setLoading(false);
    notifyListeners(); //One notify listeners here is enough
  }

  setLoading(bool state) {
    isLoading = state;
  }
}
