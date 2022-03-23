import 'package:ChatApp/constants.dart';
import 'package:ChatApp/view/screens/home_page.dart';
import 'package:ChatApp/view/screens/chat_rooms.dart';
import 'package:ChatApp/view/screens/login_screen.dart';
import 'package:ChatApp/view/screens/sign_up_screen.dart';
import 'package:ChatApp/data/services/shared_pref.dart';
import 'package:ChatApp/view/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() async {
    final newUser = await SharedPref().checkIfLoggedIn();
    if (newUser != true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage();
        }),
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SvgPicture.asset(
              'images/grchat.svg',
              height: 56.0.h,
            ),
            Text('Connect Together',
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: 23.0.sp, fontWeight: FontWeight.w500))),
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 12.5.w),
              child: Text(
                'Make conversations and chat with your friends all over the world, start now!',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SignUpScreen();
                  }));
                },
                child: CustomButton(kGreenColor, 'Get Started', Colors.white)),
            SizedBox(
              height: 1.5.h,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }));
                },
                child: CustomButton(Colors.white, 'Log in', kGreenColor)),
          ],
        ),
      ),
    );
  }
}
