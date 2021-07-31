import 'dart:io';
import 'package:ChatApp/constants.dart';
import 'package:ChatApp/models/user.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/screens/home_page.dart';
import 'package:ChatApp/widgets/submit_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  User? myUser;

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  // var url;
  // var test;
  File? file;
  bool isLoading = false;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  imageFromGallery(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null)
      setStateIfMounted(() {
        file = File(pickedFile.path);
      });
  }

  imageFromCamera(context) async {
    Navigator.pop(context);
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 70);
    if (pickedFile != null)
      setStateIfMounted(() {
        file = File(pickedFile.path);
      });
  }

  // loadImage() async {
  //   test = await databaseMethods.getPhotoFromFirebase(widget.uid);
  //   String bio = await databaseMethods.getBioFromFirebase(widget.uid);
  //   String username = await databaseMethods.getUsernameFromFirebase(widget.uid);
  //   setStateIfMounted(() {
  //     url = test;
  //     bioController.text = bio;
  //     usernameController.text = username;
  //   });
  // }
  loadData() {
    bioController.text = myUser!.bio!;
    usernameController.text = myUser!.username!;
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

  // handleSubmit() async {
  //   if (file != null) {
  //     setStateIfMounted(() {
  //       isLoading = true;
  //     });
  //     String photoUrl =
  //         await databaseMethods.uploadImageToStorge(file, uid);
  //     databaseMethods.upDateUsersInfo(
  //         uid, photoUrl, bioController.text, usernameController.text);
  //     // loadImage();
  //     setStateIfMounted(() {
  //       file = null;
  //       isLoading = false;
  //     });
  //   } else {
  //     setStateIfMounted(() {
  //       isLoading = true;
  //     });
  //     databaseMethods.upDateUsersInfo(uid, myCurrentUser!.photo,
  //         bioController.text, usernameController.text);
  //     loadImage();
  //     setStateIfMounted(() {
  //       file = null;
  //       isLoading = false;
  //     });
  //   }
  // }

  updateProfile() async {
    String photoUrl = file != null
        ? await databaseMethods.uploadImageToStorge(file, myUser!.uid!)
        : '';
    User? updatedUser = User(
        bio: bioController.text,
        photo: file == null ? myUser!.photo! : photoUrl,
        username: usernameController.text);
    print('Its the ${updatedUser.photo}');
    // User? updatedUser = User(
    //     bio: bioController.text,
    //     photo: myUser!.photo!,
    //     username: usernameController.text);
    Provider.of<UserProvider>(context, listen: false)
        .updateUserInfo(updatedUser, myUser!.uid!);
  }

  // showPhotoIcon() async {
  //   DocumentSnapshot doc = await refUsers.doc(widget.uid).get();
  //   String? url = doc['photo'];
  //   setStateIfMounted(() {
  //     photoUrl = url;
  //   });
  // }

  handleSubmit() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await updateProfile();
      setState(() {
        isLoading = false;
      });
      // showPhotoIcon();
      SnackBar snackBar = SnackBar(
        content: Text('Profile Updated'),
      );

      scaffoldkey.currentState!.showSnackBar(snackBar);
      //databaseMethods.addToNewsFeed(widget.uid);
    }
  }

  @override
  void initState() {
    super.initState();
    myUser = Provider.of<UserProvider>(context, listen: false).myUser;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldkey,
        body: isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 4.0.h),
                    Center(
                      child: Stack(
                        children: [
                          // file == null
                          //       ? NetworkImage(
                          //           myUser!.photo!,
                          //         )
                          //       : FileImage(file!)) as ImageProvider<Object>?,
                          file == null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50.5.h),
                                  child: CachedNetworkImage(
                                    height: 45.0.h,
                                    width: 45.0.h,
                                    fit: BoxFit.cover,
                                    imageUrl: myUser!.photo!,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ))
                              : CircleAvatar(
                                  radius: 100.0.sp,
                                  backgroundImage: (FileImage(file!)),
                                ),
                          // CircleAvatar(
                          //   radius: 100.0.sp,
                          //   backgroundImage: (file == null
                          //       ? NetworkImage(
                          //           myUser!.photo!,
                          //         )
                          //       : FileImage(file!)) as ImageProvider<Object>?,
                          // ),
                          Positioned(
                            bottom: 1.5.h,
                            right: 5.0.w,
                            child: GestureDetector(
                              child: CircleAvatar(
                                radius: 20.0.sp,
                                backgroundColor: kGreenColor,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 23.0.sp,
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.8.w),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: myGoogleFont(
                                  Colors.grey[500], 12.5.sp, FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 23.0.sp,
                                  color: kGreenColor,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    style: myGoogleFont(
                                        Colors.black, 12.0.sp, FontWeight.w600),
                                    validator: (val) {
                                      if (val!.trim().length <= 3)
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
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Bio',
                              style: myGoogleFont(
                                  Colors.grey[500], 12.5.sp, FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 23.0.sp,
                                  color: kGreenColor,
                                ),
                                SizedBox(
                                  width: 15.0.sp,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    style: myGoogleFont(
                                        Colors.black, 12.5.sp, FontWeight.w600),
                                    validator: (val) {
                                      if (val!.trim().length > 100)
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
                                await handleSubmit();
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
      ),
    );
  }
}
