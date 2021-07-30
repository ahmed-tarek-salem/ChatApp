import 'package:ChatApp/constants.dart';
import 'package:ChatApp/message.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/providers/messages_provider.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/screens/single_chat_room.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:ChatApp/widgets/photo_with_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UserTile extends StatefulWidget {
  final User messageUser;
  UserTile(this.messageUser);
  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<UserTile> {
  Message? myMessage;
  User? currentUser;
  var messagesProvider;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  int? count;
  getCountofUnseenMsgs() async {
    int? testCount = await databaseMethods.getCount(
        currentUser!.username!, widget.messageUser.username!);
    setStateIfMounted(() {
      count = testCount;
    });
  }

  getLastMessage() async {
    Message? myTestMessage = await databaseMethods.getLastMessage(
        widget.messageUser.username!, currentUser!.username!);
    setStateIfMounted(() {
      myMessage = myTestMessage;
    });
  }

  @override
  void didChangeDependencies() {
    currentUser = Provider.of<UserProvider>(context, listen: false).myUser;
    // messagesProvider = Provider.of<MessagesProvider>(context, listen: false);
    // messagesProvider.getNumberOfUnseenMessages(
    //     widget.messageUser, currentUser!);
    getLastMessage();
    getCountofUnseenMsgs();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    getCountofUnseenMsgs();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return SingleChatRoom(widget.messageUser);
        //     },
        //   ),
        // );
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SingleChatRoom(
            widget.messageUser,
          );
        })).then(
          (value) {
            if (value == true) {
              getCountofUnseenMsgs();
              getLastMessage();
            } else {
              getCountofUnseenMsgs();
              getLastMessage();
            }
          },
        );
      },
      child: Container(
        color: count == 0 || count == null ? Colors.white : Colors.black,
        child: Padding(
          padding: EdgeInsets.only(top: 0.6.h, bottom: 0.6.h),
          child: Container(
            height: 12.0.h,
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.25.w),
                child: Center(
                  child: ListTile(
                    leading: PhotoWithState(
                      state: widget.messageUser.state,
                      photoUrl: widget.messageUser.photo,
                      radius: 23.0.sp,
                      radiusOfBall: 5.3.sp,
                      colorOfBall: count == 0 || count == null
                          ? Colors.white
                          : Colors.green,
                    ),
                    //  CircleAvatar(
                    //   backgroundImage: CachedNetworkImageProvider(widget.messageUser.photo),
                    //   radius: 30,
                    title: Container(
                      margin: EdgeInsets.only(top: 1.5.h),
                      child: Text(
                        widget.messageUser.username!,
                        style: myGoogleFont(
                            count == 0 ? Colors.black : Colors.white,
                            12.0.sp,
                            FontWeight.w500),
                      ),
                    ),
                    subtitle: Text(
                      myMessage?.message == null
                          ? ''
                          : myMessage?.isPhoto == true
                              ? 'Sent photo'
                              : myMessage!.message,
                      // messagesProvider.lastMessage != null
                      //     ? messagesProvider.lastMessage!.message!
                      //     : widget.messageUser.bio!,
                      // overflow: TextOverflow.ellipsis,
                      // maxLines: 2,
                      // softWrap: false,
                      style: myGoogleFont(
                          count != 0 ? Colors.white : Colors.grey[600],
                          11.0.sp,
                          FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: count == 0 || count == null
                        ? Text('')
                        : Container(
                            height: 27,
                            width: 27,
                            decoration: BoxDecoration(
                                color: kGreenColor,
                                borderRadius: BorderRadius.circular(27)),
                            child: Center(
                              child: Text(
                                '$count',
                                style: myGoogleFont(
                                    Colors.black, 15, FontWeight.w600),
                              ),
                            ),
                          ),
                  ),
                )
                //   Text(
                //     '$count',
                //     style: myGoogleFont(Colors.grey[400], 16, FontWeight.w400)
                //   ),
                // ),
                // child: Row(
                //   children: [
                //     CircleAvatar(
                //       backgroundImage: CachedNetworkImageProvider(widget.messageUser.photo),
                //       radius: 30,
                //     ),
                //     Column(
                //       children: [
                //         Text(
                //           widget.messageUser.username
                //         )
                //       ],
                //     )
                //   ],
                // ),
                ),
          ),
        ),
      ),
    );
  }
}
