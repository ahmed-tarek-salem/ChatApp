import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPreferences? logindata;
  bool? newuser;

  markTheUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final newUser = prefs.getString('userId') ?? true;
    return newUser;
  }

  removeMark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }
}
