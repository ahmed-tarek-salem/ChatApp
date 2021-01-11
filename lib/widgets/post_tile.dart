import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/post.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/screens/chat_room.dart';
import 'package:ChatApp/screens/image.dart';
import 'package:ChatApp/widgets/photo_with_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/image_provider/optimized_cached_image_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostTile extends StatefulWidget {
  final Post myPost;
  PostTile(this.myPost);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  User myUser;
  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  getUser() async {
    DocumentSnapshot doc = await refUsers.doc(widget.myPost.ownerId).get();
    User myUserTest = User.fromDocument(doc);
    setStateIfMounted(() {
      myUser = myUserTest;
    });
    print(myUser.username);
  }

  handleDeletePost(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    deletePost();
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel')),
            ],
          );
        });
  }

  deletePost() async {
    //delete post itself
    DocumentSnapshot doc = await refPosts.doc(widget.myPost.postId).get();
    if (doc.exists) {
      doc.reference.delete();
    }
    //delete uploaded image from storage
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('image_${widget.myPost.postId}');
    await firebaseStorageRef.delete();

    // print('third step');
    // //delete activity feed notifications
    // QuerySnapshot snapshot = await refFeeds
    // .doc(widget.myPost.ownerId).collection('userfeeds')
    // .where('postid', isEqualTo: widget.myPost.postId).get();
    // for(int i=0; i<snapshot.docs.length; i++){
    //   if(snapshot.docs[i].exists){
    //     snapshot.docs[i].reference.delete();
    //   }
    // }
    // print('post deleted');
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        myUser == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      PhotoWithState(
                        photoUrl: myUser.photo,
                        colorOfBall: Colors.white,
                        radius: 30,
                        radiusOfBall: 7,
                        state: true,
                      ),
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            myUser.username,
                            style:
                                myGoogleFont(Colors.black, 20, FontWeight.w500),
                          ),
                          Text(
                            timeago.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  widget.myPost.timeStamp),
                            ),
                            style: myGoogleFont(
                                Colors.grey[500], 15, FontWeight.w200),
                          ),
                        ],
                      ),
                    ],
                  ),
                  widget.myPost.ownerId != myCurrentUser.uid
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            handleDeletePost(context);
                          },
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  radius: 3,
                                ),
                                SizedBox(height: 8),
                                CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  radius: 3,
                                ),
                              ],
                            ),
                          ),
                        )
                ],
              ),
        SizedBox(height: 10),
        widget.myPost.des == ""
            ? Container()
            : Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 5, bottom: 5),
                    child: Text(widget.myPost.des,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        )),
                  ),
                ],
              ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          height: 350,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ImageScreen(widget.myPost.mediaUrl);
                }),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image(
                fit: BoxFit.cover,
                image: OptimizedCacheImageProvider(widget.myPost.mediaUrl,
                    cacheWidth: 50, cacheHeight: 50),
              ),
            ),
          ),
        ),
        widget.myPost.location == ""
            ? Container()
            : Container(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      size: 35,
                      color: kGreenColor,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.myPost.location.toUpperCase(),
                        style: myGoogleFont(kGreenColor, 15, FontWeight.w700),
                      ),
                    )
                  ],
                ),
              ),
        SizedBox(height: 10),
        Divider(),
        SizedBox(height: 10),
      ],
    );
  }
}
