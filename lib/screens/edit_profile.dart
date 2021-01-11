import 'dart:io';
import 'package:ChatApp/constants.dart';
import 'package:ChatApp/screens/chat_room.dart';
import 'package:ChatApp/widgets/submit_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:optimized_cached_image/image_provider/optimized_cached_image_provider.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  EditProfile(
    this.uid,
  );
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  var url;
  var test;
  File file;
  bool isLoading = false;

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
  }

  imageFromCamera(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    setStateIfMounted(() {
      file = File(pickedFile.path);
    });
  }

  loadImage() async {
    test = await databaseMethods.getPhotoFromFirebase(widget.uid);
    String bio = await databaseMethods.getBioFromFirebase(widget.uid);
    String username = await databaseMethods.getUsernameFromFirebase(widget.uid);
    setStateIfMounted(() {
      url = test;
      bioController.text = bio;
      usernameController.text = username;
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Upload a photo'),
            children: [
              SimpleDialogOption(
                child: Text(
                  'Choose an image From Gallery',
                ),
                onPressed: () {
                  imageFromGallery(parentContext);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Open camera',
                ),
                onPressed: () {
                  imageFromCamera(parentContext);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  'Cancel',
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  handleSubmit() async {
    if (file != null) {
      setStateIfMounted(() {
        isLoading = true;
      });
      String photoUrl =
          await databaseMethods.uploadImageToStorge(file, widget.uid);
      databaseMethods.upDateUsersInfo(
          widget.uid, photoUrl, bioController.text, usernameController.text);
      loadImage();
      setStateIfMounted(() {
        file = null;
        isLoading = false;
      });
    } else {
      setStateIfMounted(() {
        isLoading = true;
      });
      databaseMethods.upDateUsersInfo(widget.uid, myCurrentUser.photo,
          bioController.text, usernameController.text);
      loadImage();
      setStateIfMounted(() {
        file = null;
        isLoading = false;
      });
    }
  }

  showPhotoIcon() async {
    DocumentSnapshot doc = await refUsers.doc(widget.uid).get();
    String url = doc['photo'];
    setStateIfMounted(() {
      photoUrl = url;
    });
  }

  updateProfile() async {
    if (formKey.currentState.validate()) {
      await handleSubmit();
      showPhotoIcon();
      SnackBar snackBar = SnackBar(
        content: Text('Profile Updated'),
      );
      scaffoldkey.currentState.showSnackBar(snackBar);
      //databaseMethods.addToNewsFeed(widget.uid);
    }
  }

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  // @override
  // void dispose() {
  //    loadImage();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      body: url == null || isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 25),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                            radius: 130,
                            backgroundImage: file == null
                                ? OptimizedCacheImageProvider(url,
                                    cacheWidth: 40, cacheHeight: 40)
                                : FileImage(file)),
                        Positioned(
                          bottom: 10,
                          right: 20,
                          child: GestureDetector(
                            child: CircleAvatar(
                              radius: 26,
                              backgroundColor: kGreenColor,
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            onTap: () {
                              selectImage(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username',
                            style: myGoogleFont(
                                Colors.grey[500], 16, FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 30,
                                color: kGreenColor,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  style: myGoogleFont(
                                      Colors.black, 16, FontWeight.w600),
                                  validator: (val) {
                                    if (val.trim().length <= 3)
                                      return 'Username is too short';
                                    else
                                      return null;
                                  },
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                      hintText: 'Update username'),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Bio',
                            style: myGoogleFont(
                                Colors.grey[500], 16, FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 30,
                                color: kGreenColor,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: TextFormField(
                                  style: myGoogleFont(
                                      Colors.black, 16, FontWeight.w600),
                                  validator: (val) {
                                    if (val.trim().length > 100)
                                      return 'Bio is too long';
                                    else
                                      return null;
                                  },
                                  controller: bioController,
                                  decoration:
                                      InputDecoration(hintText: 'Update bio'),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              await updateProfile();
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChatRoom(
                                  widget.uid,
                                  urll: url,
                                );
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 20),
                              child: SubmitButton('Update profile'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
