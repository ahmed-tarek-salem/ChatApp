import 'package:ChatApp/constants.dart';
import 'package:ChatApp/screens/chat_room.dart';
import 'package:ChatApp/screens/home.dart';
import 'package:ChatApp/screens/log_in_screen.dart';
import 'package:ChatApp/screens/sign_up_screen.dart';
import 'package:ChatApp/services/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void didChangeDependencies() async {
    final newUser = await SharedPref().checkIfLoggedIn();
    if (newUser != true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return ChatRoom(newUser);
        }),
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SvgPicture.asset(
            'images/grchat.svg',
            height: 400,
          ),
          Text('Connect Together',
              style: GoogleFonts.montserrat(
                  textStyle:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.w500))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50),
            child: Text(
                'Make conversations and chat with your friends all over the world, start now!',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey))),
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SignUpScreen();
                }));
              },
              child: CustomButton(kGreenColor, 'Get Started', Colors.white)),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return LogInScreen();
                }));
              },
              child: CustomButton(Colors.white, 'Log in', kGreenColor)),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color myColor;
  final String myTitle;
  final Color titleColor;
  CustomButton(this.myColor, this.myTitle, this.titleColor);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        color: myColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Center(
        child: Text(
          myTitle,
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  fontSize: 20,
                  color: titleColor,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
