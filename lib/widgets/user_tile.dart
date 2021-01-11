import 'package:ChatApp/constants.dart';
import 'package:ChatApp/message.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/screens/chat.dart';
import 'package:ChatApp/screens/chat_room.dart';
import 'package:ChatApp/widgets/photo_with_state.dart';
import 'package:flutter/material.dart';

class UserTile extends StatefulWidget {
  final User messageUser;
  UserTile(this.messageUser);
  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<UserTile> {
  Message myMessage;
   void setStateIfMounted(f) {
  if (mounted) setState(f);
}
  int count;
  getCountofUnseenMsgs() async {
    int testCount = await databaseMethods.getCount(
        myCurrentUser.username, widget.messageUser.username);
    setStateIfMounted(() {
      count = testCount;
    });
  }
  getLastMessage()async{
    Message myTestMessage = await databaseMethods.
    getLastMessage(widget.messageUser.username, myCurrentUser.username);
    setStateIfMounted(() {
      myMessage= myTestMessage;
    });
    
  }

  @override
  void initState() {
    getCountofUnseenMsgs();
    getLastMessage();
    super.initState();
  }
  //  @override
  // void dispose() {
  //   getCountofUnseenMsgs();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Chat(
            widget.messageUser,
          );
        })).then((value) {
          if (value){ getCountofUnseenMsgs();
           getLastMessage();
          }
        });
      },
      child: Container(
        color: count == 0 || count == null ? Colors.white : Colors.black,
        child:
         Padding(
          padding: const EdgeInsets.only(
            top: 4.0,
            bottom: 4
          ),
          child: Container(
            height: 80,
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 33),
                child: Center(
                  child: ListTile(
                    leading: PhotoWithState(
                      state: widget.messageUser.state,
                      photoUrl: widget.messageUser.photo,
                      radius: 30,
                      radiusOfBall: 7,
                      colorOfBall: count == 0 || count == null
                          ? Colors.white
                          : Colors.black,
                    ),
                    //  CircleAvatar(
                    //   backgroundImage: CachedNetworkImageProvider(widget.messageUser.photo),
                    //   radius: 30,
                    title: Container(
                      margin: EdgeInsets.only(top:10),
                      child: Text(
                        widget.messageUser.username,
                        style: myGoogleFont(
                            count == 0 ? Colors.black : Colors.white,
                            16,
                            FontWeight.w500),
                      ),
                    ),
                    subtitle: Text(
                      myMessage != null ? myMessage.message : widget.messageUser.bio,
                     // overflow: TextOverflow.ellipsis,
                      // maxLines: 2,
                      // softWrap: false,
                      style: myGoogleFont(
                          count != 0 ? Colors.white : Colors.grey[600],
                          14,
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