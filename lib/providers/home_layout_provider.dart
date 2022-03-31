import 'package:ChatApp/data/services/shared_pref.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomeLayoutProvider extends ChangeNotifier {
  bool isLoading = true;
  int currentIndex = 0;
  void setLoading(bool state) {
    isLoading = state;
  }

  setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  retrieveUsersData(BuildContext context) async {
    setLoading(true);
    final userAlreadyLoggedInId = await SharedPref().checkIfLoggedIn();
    if (userAlreadyLoggedInId != true) {
      print("HEEEREE");
      await Provider.of<UserProvider>(context, listen: false)
          .defineUser(userAlreadyLoggedInId);
    }
    setLoading(false);
    notifyListeners();
  }
}
