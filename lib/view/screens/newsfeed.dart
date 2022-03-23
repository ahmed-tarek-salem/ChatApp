import 'dart:io';

import 'package:ChatApp/constants.dart';
import 'package:ChatApp/data/models/post.dart';
import 'package:ChatApp/view/screens/uploading_screen.dart';
import 'package:ChatApp/view/widgets/custom_progress_indicator.dart';
import 'package:ChatApp/view/widgets/post_tile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ChatApp/view/screens/home_page.dart';
import 'package:sizer/sizer.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  File? file;
  Stream<QuerySnapshot>? mySnapshot =
      refPosts.orderBy('timestamp', descending: true).snapshots();
  Stream<QuerySnapshot>? returnSnapshot() {
    return refPosts.orderBy('timestamp', descending: true).snapshots();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  imageFromGallery(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setStateIfMounted(
        () {
          file = File(pickedFile.path);
        },
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return UploadingScreen(file);
          },
        ),
      );
    }
  }

  Future<void> refresh() async {
    returnSnapshot();
  }

  imageFromCamera(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 70);
    if (pickedFile != null) {
      setStateIfMounted(() {
        file = File(pickedFile.path);
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return UploadingScreen(file);
          },
        ),
      );
    }
  }

  Future<File?> selectImage(parentContext) async {
    return await showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Upload a photo'),
            children: [
              SimpleDialogOption(
                child: Text(
                  'Choose an image From Gallery',
                ),
                onPressed: () async {
                  await imageFromGallery(parentContext);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Open camera',
                ),
                onPressed: () async {
                  return await imageFromCamera(parentContext);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // file!=null ? Upload(file) :
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22),
      child: Scaffold(
          floatingActionButton: Container(
            height: 60,
            width: 60,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  selectImage(context);
                },
                backgroundColor: kGreenColor,
                child: Icon(
                  Icons.add,
                  size: 35,
                ),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 9.0.h,
                ),
                Center(
                  child: Text(
                    'Explore',
                    style: myGoogleFont(Colors.black, 26.0.sp, FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.75.w),
                  child: TextField(
                    onChanged: (value) {
                      Stream<QuerySnapshot> snapshot = refPosts
                          .where('description', isGreaterThanOrEqualTo: value)
                          .snapshots();
                      setState(() {
                        mySnapshot = snapshot;
                      });
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.grey[100],
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[100]!, width: 1)),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.greenAccent, width: 1)),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 1)),
                        errorStyle:
                            myGoogleFont(Colors.red, 12.0.sp, FontWeight.w500)),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: mySnapshot,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CustomProgressIndicator();
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: (snapshot.data!).docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot doc = (snapshot.data!).docs[index];
                            Post myPost = Post.fromDocument(doc);
                            return PostTile(myPost);
                          });
                    }
                  },
                )
              ],
            ),
          )),
    );
  }
}
