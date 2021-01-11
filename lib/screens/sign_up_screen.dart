import 'package:ChatApp/constants.dart';
import 'package:ChatApp/screens/chat_room.dart';
import 'package:ChatApp/screens/log_in_screen.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/shared_pref.dart';
import 'package:ChatApp/widgets/submit_button.dart';
import 'package:ChatApp/widgets/text_field.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    userName.dispose();
    super.dispose();
  }

  var formkey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userName = TextEditingController();
  AuthMethods authMethods = AuthMethods();

  signUp(BuildContext context) async {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      String uid = await authMethods.signUp(email.text, password.text);
      if (uid != null) {
        Map<String, dynamic> myMap = {
          'email': email.text,
          'username': userName.text,
          'photo':
              'https://www.xovi.com/wp-content/plugins/all-in-one-seo-pack/images/default-user-image.png',
          'bio': 'Available',
          'uid': uid,
          'state': true
        };
        databaseMethods.setUserInfo(myMap, uid);
        SharedPref().markTheUser(uid);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ChatRoom(uid);
        }));
      } else {
        return await showErrorDialog();
      }
    }
  }

  showErrorDialog() async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('An error occured'),
            content: Text('Something went wrong'),
            actions: [
              FlatButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 500,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40)),
                          child: Image(
                            image: AssetImage('images/photo5.png'),
                            height: 500,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 500,
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40))),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: 80, right: 50, left: 50),
                          child: Form(
                            key: formkey,
                            child: Column(
                              children: [
                                Text('Sign up',
                                    style: myGoogleFont(
                                        Colors.white, 25, FontWeight.w400)),
                                SizedBox(
                                  height: 45,
                                ),
                                MyTextField('Email', Colors.white, false, email,
                                    (email) {
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(email);
                                  if (!emailValid)
                                    return 'Please enter a valid email';
                                }),
                                SizedBox(
                                  height: 20,
                                ),
                                MyTextField(
                                    'Username', Colors.white, false, userName,
                                    (username) {
                                  return username.length < 2
                                      ? 'Enter a +2 charachter password'
                                      : null;
                                }),
                                SizedBox(
                                  height: 20,
                                ),
                                MyTextField(
                                    'Password', Colors.white, true, password,
                                    (password) {
                                  return password.length < 6
                                      ? 'Enter a +6 charachter password'
                                      : null;
                                }),
                                SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      signUp(context);
                                    },
                                    child: SubmitButton('Sign up'))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already registered? ',
                        style: myGoogleFont(Colors.black, 16, FontWeight.w300),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return LogInScreen();
                          }));
                        },
                        child: Text(
                          'Sign in',
                          style: myGoogleFont(
                              Colors.greenAccent, 18, FontWeight.w500),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
