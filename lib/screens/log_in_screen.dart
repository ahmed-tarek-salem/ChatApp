import 'package:ChatApp/constants.dart';
import 'package:ChatApp/screens/chat_room.dart';
import 'package:ChatApp/screens/sign_up_screen.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/shared_pref.dart';
import 'package:ChatApp/widgets/submit_button.dart';
import 'package:ChatApp/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInScreen extends StatefulWidget {
  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  var formkey = GlobalKey<FormState>();
  String error = '';
  bool isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  AuthMethods authMethods = AuthMethods();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  logIn(BuildContext context) async {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      var uid = await authMethods.logIn(email.text, password.text);
      if (uid == null) {
        setState(() {
          isLoading = false;
        });
        return showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text("Email or password isn't correct"),
                children: <Widget>[
                  SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(color: Colors.red),
                      )),
                  // SimpleDialogOption(
                  //     onPressed: () => Navigator.pop(context),
                  //     child: Text('Cancel')),
                ],
              );
            });
      } else {
        SharedPref().markTheUser(uid);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ChatRoom(uid);
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 310,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
                              child: Image(
                                image: AssetImage('images/photo6.png'),
                                height: 310,
                              ),
                            ),
                          ),
                          Container(
                            height: 310,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                                color: Colors.black26),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 100,
                            child: Row(
                              children: [
                                Text('Not a member? ',
                                    style: myGoogleFont(
                                        Colors.white, 16, FontWeight.w300)),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return SignUpScreen();
                                    }));
                                  },
                                  child: Text('Sign up',
                                      style: myGoogleFont(Colors.greenAccent,
                                          18, FontWeight.w500)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30),
                        child: Text('Log in',
                            style: myGoogleFont(
                                Colors.black45, 25, FontWeight.w400)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Form(
                          key: formkey,
                          child: Column(
                            children: [
                              MyTextField(
                                  'Email', Colors.grey[300], false, email,
                                  (email) {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(email);
                                if (!emailValid)
                                  return 'Please enter a valid email';
                              }),
                              SizedBox(
                                height: 15,
                              ),
                              MyTextField(
                                  'Password', Colors.grey[300], true, password,
                                  (password) {
                                return password.length == 0
                                    ? 'Please enter a password'
                                    : null;
                              }),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    logIn(context);
                                  },
                                  child: SubmitButton('Log in')),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Forgot Password?',
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(color: kGreenColor)),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
