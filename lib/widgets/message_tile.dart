import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/screens/image.dart';
import 'package:ChatApp/widgets/custom_progress_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageTile extends StatefulWidget {
  final User? messageSender;
  final String? message;
  final bool? isPhoto;
  final timeStamp;

  MessageTile({this.message, this.messageSender, this.isPhoto, this.timeStamp});

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  User? myCurrentUser;
  bool isFirstTime = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isFirstTime) {
      myCurrentUser = Provider.of<UserProvider>(context, listen: false).myUser;
      isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  bool showData = false;
  @override
  Widget build(BuildContext context) {
    return widget.isPhoto == true
        ? GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ImageScreen(widget.message);
              }));
            },
            child: Container(
              margin: widget.messageSender!.uid == myCurrentUser!.uid
                  ? EdgeInsets.only(left: 25.0.w, bottom: 2.0.h)
                  : EdgeInsets.only(right: 25.0.w, bottom: 2.0.h),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 0),
                width: double.infinity,
                height: 44.0.h,
                child: ClipRRect(
                    //            borderRadius: messageSender.uid == myCurrentUser.uid ? BorderRadius.only(topRight: Radius.circular(50))
                    //  : BorderRadius.only(topLeft: Radius.circular(50)),
                    child: CachedNetworkImage(
                  imageUrl: widget.message!,
                  placeholder: (context, string) => CustomProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  alignment: widget.messageSender!.uid != myCurrentUser!.uid
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  fit: BoxFit.fill,
                )
                    //  Image(
                    //   image: NetworkImage(widget.message!),
                    //   alignment: widget.messageSender!.uid != myCurrentUser!.uid
                    //       ? Alignment.centerLeft
                    //       : Alignment.centerRight,
                    //   fit: BoxFit.cover,
                    // ),
                    ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              setStateIfMounted(() {
                if (showData == false)
                  showData = true;
                else
                  showData = false;
              });
            },
            child: Container(
              // margin: widget.messageSender.uid == myCurrentUser.uid
              //     ? EdgeInsets.only(top: 0)
              //     : EdgeInsets.only(top: 0),
              child: Column(
                crossAxisAlignment:
                    widget.messageSender!.uid != myCurrentUser!.uid
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 9.75.w, vertical: 0),
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.0.w, vertical: 2.5.h),
                    constraints:
                        BoxConstraints(minWidth: 37.5.w, maxWidth: 75.0.w),
                    decoration: BoxDecoration(
                      color: widget.messageSender!.uid != myCurrentUser!.uid
                          ? Colors.grey[100]
                          : Colors.black,
                      borderRadius:
                          widget.messageSender!.uid == myCurrentUser!.uid
                              ? BorderRadius.only(
                                  topRight: Radius.circular(25.0.sp),
                                )
                              : BorderRadius.only(
                                  topLeft: Radius.circular(25.0.sp),
                                ),
                    ),
                    child: Text(widget.message!,
                        style: widget.messageSender!.uid != myCurrentUser!.uid
                            ? myGoogleFont(
                                Colors.black, 12.3.sp, FontWeight.w400)
                            : myGoogleFont(
                                Colors.white, 12.3.sp, FontWeight.w400)),
                  ),
                  Align(
                    child: Container(
                      // margin: showData == true
                      //     ? EdgeInsets.symmetric(vertical: 0)
                      //     : EdgeInsets.symmetric(vertical: 0),
                      child: showData == false
                          ? Text('')
                          : Text(timeago.format(widget.timeStamp),
                              style: myGoogleFont(
                                  Colors.grey[400], 12.3.sp, FontWeight.w400,
                                  letterSpacing: -.9)),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
