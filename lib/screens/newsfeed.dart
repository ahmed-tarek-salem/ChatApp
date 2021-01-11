import 'dart:io';

import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/post.dart';
import 'package:ChatApp/screens/upload.dart';
import 'package:ChatApp/widgets/post_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ChatApp/screens/chat_room.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  File file;
  Stream<QuerySnapshot> mySnapshot;
  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  imageFromGallery(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 85);
    setStateIfMounted(() {
      file = File(pickedFile.path);
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Upload(file);
    }));
  }

  imageFromCamera(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setStateIfMounted(() {
      file = File(pickedFile.path);
    });
  }

  Future<File> selectImage(parentContext) async {
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
          body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60,
              ),
              Center(
                child: Text(
                  'Explore',
                  style: myGoogleFont(Colors.black, 35, FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
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
                              BorderSide(color: Colors.grey[100], width: 1)),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1)),
                      errorStyle:
                          myGoogleFont(Colors.red, 14, FontWeight.w500)),
                ),
              ),
              StreamBuilder(
                stream: mySnapshot == null
                    ? refPosts
                        .orderBy('timestamp', descending: true)
                        .snapshots()
                    : mySnapshot,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data.docs[index];
                          Post myPost = Post.fromDocument(doc);
                          return PostTile(myPost);
                        });
                  }
                },
              )
            ],
          )),
    );
  }
}
