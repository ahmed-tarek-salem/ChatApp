import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/post.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:ChatApp/screens/image.dart';
import 'package:ChatApp/screens/user_profile.dart';
import 'package:ChatApp/widgets/photo_with_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:sizer/sizer.dart';

class PostTile extends StatefulWidget {
  final Post myPost;
  PostTile(this.myPost);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  User? postUser;
  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  getUser() async {
    DocumentSnapshot doc = await refUsers.doc(widget.myPost.ownerId).get();
    User postUserTest = User.fromDocument(doc);
    setStateIfMounted(() {
      postUser = postUserTest;
    });
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
    Reference firebaseStorageRef =
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
        postUser == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return UserProfile(postUser!);
                              },
                            ),
                          );
                        },
                        child: PhotoWithState(
                          photoUrl: postUser!.photo,
                          colorOfBall: Colors.white,
                          radius: 40.0.sp,
                          radiusOfBall: 5.3.sp,
                          state: postUser!.state,
                        ),
                      ),
                      SizedBox(width: 5.0.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return UserProfile(postUser!);
                                  },
                                ),
                              );
                            },
                            child: Text(
                              postUser!.username!,
                              style: myGoogleFont(
                                  Colors.black, 15.0.sp, FontWeight.w500),
                            ),
                          ),
                          Text(
                            timeago.format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  widget.myPost.timeStamp),
                            ),
                            style: myGoogleFont(
                                Colors.grey[500], 12.5.sp, FontWeight.w200),
                          ),
                        ],
                      ),
                    ],
                  ),
                  widget.myPost.ownerId !=
                          Provider.of<UserProvider>(context).myUser?.uid
                      ? Container()
                      : GestureDetector(
                          onTap: () {
                            handleDeletePost(context);
                          },
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 1.5.h, horizontal: 2.5.w),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  radius: 2.5.sp,
                                ),
                                SizedBox(height: 8),
                                CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  radius: 2.5.sp,
                                ),
                              ],
                            ),
                          ),
                        )
                ],
              ),
        SizedBox(height: 1.5.h),
        widget.myPost.des == ""
            ? Container()
            : Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 5, bottom: 5),
                    child: Text(widget.myPost.des!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5.sp,
                        )),
                  ),
                ],
              ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 52.0.h,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ImageScreen(widget.myPost.mediaUrl);
                }),
              );
            },
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: widget.myPost.mediaUrl!,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
              maxHeightDiskCache: 300,
              maxWidthDiskCache: 300,
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
                      size: 26.0.sp,
                      color: kGreenColor,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.myPost.location!.toUpperCase(),
                        style:
                            myGoogleFont(kGreenColor, 12.5.sp, FontWeight.w700),
                      ),
                    )
                  ],
                ),
              ),
        const SizedBox(height: 10),
        Divider(),
        const SizedBox(height: 10),
      ],
    );
  }
}
