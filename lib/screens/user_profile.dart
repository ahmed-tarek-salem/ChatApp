import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/screens/single_chat_room.dart';
import 'package:ChatApp/widgets/submit_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UserProfile extends StatefulWidget {
  final User myUser;
  UserProfile(this.myUser);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User? myUser;

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView(children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Hero(
              tag: 'ProfilePhoto',
              child: CachedNetworkImage(
                height: 70.0.h,
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: widget.myUser.photo!,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Container(
              height: 4.4.h,
              width: 103.25.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(21.0.sp),
                      topLeft: Radius.circular(21.0.sp)),
                  color: Colors.white),
            ),
            Positioned(
              bottom: -.9.h,
              right: 7.5.w,
              child: CircleAvatar(
                radius: 26.0.sp,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 20.0.sp,
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
                widget.myUser.username!,
                style: myGoogleFont(Colors.black, 23.0.sp, FontWeight.w500),
              ),
              Text(
                widget.myUser.bio!,
                textAlign: TextAlign.center,
                style: myGoogleFont(Colors.grey[550], 11.5.sp, FontWeight.w400),
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
                        return SingleChatRoom(widget.myUser);
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
      ])),
    );
  }
}
