import 'package:ChatApp/constants.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:ChatApp/screens/log_in_screen.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/shared_pref.dart';
import 'package:ChatApp/widgets/submit_button.dart';
import 'package:ChatApp/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
    if (formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      String? uid = await authMethods.signUp(email.text, password.text);
      if (uid != null) {
        Map<String, dynamic> myMap = {
          'email': email.text,
          'username': userName.text,
          'photo':
              'https://firebasestorage.googleapis.com/v0/b/chatappfromscratch.appspot.com/o/user.png?alt=media&token=40743cd8-786f-48cf-bf15-193707d4b1f8',
          'bio': 'Available',
          'uid': uid,
          'state': true
        };
        await databaseMethods.setUserInfo(myMap, uid);
        await SharedPref().markTheUser(uid);
        Provider.of<UserProvider>(context, listen: false).defineUser(uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
        );
      } else {
        setState(() {
          isLoading = false;
        });
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
              TextButton(
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
    return SafeArea(
      child: Scaffold(
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
                          height: 74.0.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0.sp),
                              bottomRight: Radius.circular(30.0.sp),
                            ),
                            child: Image(
                              image: AssetImage('images/photo5.png'),
                              // height: 74.0.h,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 74.0.h,
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0.sp),
                              bottomRight: Radius.circular(30.0.sp),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 12.2.h, right: 12.5.w, left: 12.5.w),
                            child: Form(
                              key: formkey,
                              child: Column(
                                children: [
                                  Text('Sign up',
                                      style: myGoogleFont(Colors.white, 19.0.sp,
                                          FontWeight.w400)),
                                  SizedBox(
                                    height: 6.7.h,
                                  ),
                                  MyTextField(
                                    'Email',
                                    Colors.white,
                                    false,
                                    email,
                                    (email) {
                                      bool emailValid = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(email);
                                      if (!emailValid)
                                        return 'Please enter a valid email';
                                    },
                                  ),
                                  SizedBox(
                                    height: 3.0.h,
                                  ),
                                  MyTextField(
                                    'Username',
                                    Colors.white,
                                    false,
                                    userName,
                                    (username) {
                                      return username.length < 2
                                          ? 'Enter a +2 charachter password'
                                          : null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 3.0.h,
                                  ),
                                  MyTextField(
                                      'Password', Colors.white, true, password,
                                      (password) {
                                    return password.length < 6
                                        ? 'Enter a +6 charachter password'
                                        : null;
                                  }),
                                  SizedBox(
                                    height: 4.4.h,
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
                    // SizedBox(
                    //   height: 75,
                    // ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Already registered? ',
                            style: myGoogleFont(
                                Colors.black, 12.0.sp, FontWeight.w300),
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
                                  Colors.greenAccent, 14.0.sp, FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
