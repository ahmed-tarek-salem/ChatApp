import 'package:ChatApp/screens/chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      //  await refUsers.doc(firebaseUser.uid).update({
      //   'state': true
      // });
      return firebaseUser.uid;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future logIn(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      await refUsers.doc(firebaseUser.uid).update({'state': true});
      return firebaseUser.uid;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
