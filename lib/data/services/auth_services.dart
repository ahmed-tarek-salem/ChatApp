import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/view/screens/home_page.dart';
import 'package:ChatApp/view/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future signUp(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user!;
      return firebaseUser.uid;
    } catch (e) {
      return null;
    }
  }

  Future logIn(String email, String password) async {
    try {
      var result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user!;
      await refUsers.doc(firebaseUser.uid).update({'state': true});
      return firebaseUser.uid;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> logOut(String? uid) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      await refUsers.doc(uid).update({'state': false});
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  showLogoutDialouge(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
    showDialog(
        context: scaffoldKey.currentContext!,
        builder: (context) {
          return SimpleDialog(
            title: Text("Are you sure you want to log out?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context);
                    await Provider.of<UserProvider>(context, listen: false)
                        .logout();
                    Navigator.pushReplacement(
                      scaffoldKey.currentContext!,
                      MaterialPageRoute(
                        builder: (context) {
                          return SplashScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }
}
