import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/screens/chat.dart';
import 'package:ChatApp/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/image_provider/optimized_cached_image_provider.dart';

class UserProfile extends StatefulWidget {
  final User myUser;
  UserProfile(this.myUser);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User myUser;

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Hero(
            tag: 'ProfilePhoto',
               child: Image(
              height: 500,
              width: double.infinity,
              image: OptimizedCacheImageProvider(widget.myUser.photo),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 30,
            width: 413,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25)),
                color: Colors.white),
          ),
          Positioned(
            bottom: -5,
            right: 30,
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: widget.myUser.state == true
                    ? kGreenColor
                    : Colors.grey[300],
              ),
            ),
          )
        ],
      ),
      Container(
        child: Center(
            child: Column(
          children: [
            Text(
              widget.myUser.username,
              style: myGoogleFont(Colors.black, 30, FontWeight.w500),
            ),
            Text(
              widget.myUser.bio,
              textAlign: TextAlign.center,
              style: myGoogleFont(Colors.grey[550], 15, FontWeight.w400),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Chat(widget.myUser);
                    }));
                  },
                  child: SubmitButton('Send Message',
                      myColor: widget.myUser.state == true
                          ? null
                          : Colors.grey[300])),
            )
          ],
        )),
      )
    ]));
  }
}
