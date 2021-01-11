import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/screens/image.dart';
import 'package:flutter/material.dart';
import 'package:ChatApp/screens/chat_room.dart';
import 'package:optimized_cached_image/image_provider/optimized_cached_image_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageTile extends StatefulWidget {
  final User messageSender;
  final String message;
  final bool isPhoto;
  final timeStamp;
  MessageTile({this.message, this.messageSender, this.isPhoto, this.timeStamp});

  @override
  _MessageTileState createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
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
              margin: widget.messageSender.uid == myCurrentUser.uid
                  ? EdgeInsets.only(left: 100, bottom: 12)
                  : EdgeInsets.only(right: 100, bottom: 12),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 39, vertical: 0),
                width: double.infinity,
                height: 300,
                child: ClipRRect(
                  //            borderRadius: messageSender.uid == myCurrentUser.uid ? BorderRadius.only(topRight: Radius.circular(50))
                  //  : BorderRadius.only(topLeft: Radius.circular(50)),
                  child: Image(
                    image: OptimizedCacheImageProvider(widget.message),
                    alignment: widget.messageSender.uid != myCurrentUser.uid
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    fit: BoxFit.cover,
                  ),
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
                    widget.messageSender.uid != myCurrentUser.uid
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 39, vertical: 0),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    constraints: BoxConstraints(minWidth: 150, maxWidth: 300),
                    decoration: BoxDecoration(
                        color: widget.messageSender.uid != myCurrentUser.uid
                            ? Colors.grey[100]
                            : Colors.black,
                        borderRadius: widget.messageSender.uid ==
                                myCurrentUser.uid
                            ? BorderRadius.only(topRight: Radius.circular(30))
                            : BorderRadius.only(topLeft: Radius.circular(30))),
                    child: Text(widget.message,
                        style: widget.messageSender.uid != myCurrentUser.uid
                            ? myGoogleFont(Colors.black, 16, FontWeight.w400)
                            : myGoogleFont(Colors.white, 16, FontWeight.w400)),
                  ),
                  Align(
                    child: Container(
                      margin: showData == true
                          ? EdgeInsets.symmetric(vertical: 0)
                          : EdgeInsets.symmetric(vertical: 0),
                      child: showData == false
                          ? Text('')
                          : Text(timeago.format(widget.timeStamp),
                              style: myGoogleFont(
                                  Colors.grey[400], 16, FontWeight.w400,
                                  letterSpacing: -.9)),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
