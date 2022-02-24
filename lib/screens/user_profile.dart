import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:ChatApp/screens/single_chat_room.dart';
import 'package:ChatApp/services/followers.dart';
import 'package:ChatApp/widgets/custom_progress_indicator.dart';
import 'package:ChatApp/widgets/submit_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UserProfile extends StatefulWidget {
  final User _user;
  UserProfile(this._user);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Followers _followers = Followers();
  bool isLoading = false;
  String? currentUserId;
  bool? isFollowed;
  @override
  void initState() {
    super.initState();

    currentUserId =
        Provider.of<UserProvider>(context, listen: false).myUser!.uid;
    getFollowingState();
  }

  getFollowingState() async {
    setState(() {
      isLoading = true;
    });

    isFollowed =
        await _followers.getStateFollowing(currentUserId!, widget._user.uid!);
    setState(() {
      isLoading = false;
    });
  }

  handleFolowingButtonSubmit() async {
    bool completed = false;
    if (isFollowed == false) {
      completed =
          await _followers.followFriend(currentUserId!, widget._user.uid!);
    } else {
      completed =
          await _followers.unfollowFriend(currentUserId!, widget._user.uid!);
    }
    if (completed == true) {
      print('Opposite');
      setState(() {
        isFollowed = isFollowed == true ? false : true;
      });
    }
  }

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
                height: 55.0.h,
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: widget._user.photo!,
                placeholder: (context, url) => CustomProgressIndicator(),
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
                  backgroundColor: widget._user.state == true
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
                widget._user.username!,
                style: myGoogleFont(Colors.black, 23.0.sp, FontWeight.w500),
              ),
              Text(
                widget._user.bio!,
                textAlign: TextAlign.center,
                style: myGoogleFont(Colors.grey[550], 11.5.sp, FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SingleChatRoom(widget._user);
                        }));
                      },
                      child: SubmitButton(
                        'Send Message',
                        myColor: widget._user.state == true
                            ? null
                            : Colors.grey[300],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Visibility(
                      visible: !isLoading,
                      child: GestureDetector(
                        onTap: handleFolowingButtonSubmit,
                        child: isFollowed == true
                            ? SubmitButton(
                                'Unfollow',
                                myColor: Colors.black,
                              )
                            : SubmitButton(
                                'Follow',
                                myColor: Colors.black,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
        )
      ])),
    );
  }
}
