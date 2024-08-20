import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:ChatApp/screens/sign_up_screen.dart';
import 'package:ChatApp/services/auth.dart';
import 'package:ChatApp/services/shared_pref.dart';
import 'package:ChatApp/widgets/submit_button.dart';
import 'package:ChatApp/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
    if (formkey.currentState!.validate()) {
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
        await SharedPref().markTheUser(uid);
        User user = await Provider.of<UserProvider>(context, listen: false)
            .defineUser(uid);
        print(user.photo);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                              height: 45.5.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30.0.sp),
                                  bottomRight: Radius.circular(30.0.sp),
                                ),
                                child: Image(
                                  image: AssetImage('images/photo6.png'),
                                  height: 45.5.h,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Container(
                              height: 45.5.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30.0.sp),
                                  bottomRight: Radius.circular(30.0.sp),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Not a member? ',
                                        style: myGoogleFont(Colors.white, 14.sp,
                                            FontWeight.w500)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return SignUpScreen();
                                        }));
                                      },
                                      child: Text('Sign up',
                                          style: myGoogleFont(
                                              Colors.greenAccent,
                                              16.0.sp,
                                              FontWeight.w700)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 2.5.h),
                          child: Text('Log in',
                              style: myGoogleFont(
                                  Colors.black45, 19.0.sp, FontWeight.w400)),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.5.w),
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
                                const SizedBox(
                                  height: 15,
                                ),
                                MyTextField('Password', Colors.grey[300], true,
                                    password, (password) {
                                  return password.length == 0
                                      ? 'Please enter a password'
                                      : null;
                                }),
                                SizedBox(
                                  height: 2.5.h,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      logIn(context);
                                    },
                                    child: SubmitButton('Log in')),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(color: kGreenColor),
                                      fontSize: 14.0.sp),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
    );
  }
}
