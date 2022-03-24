import 'dart:io';
import 'package:ChatApp/constants.dart';
import 'package:ChatApp/data/models/user.dart';
import 'package:ChatApp/data/models/user_spec.dart';
import 'package:ChatApp/data/services/storage_services.dart';
import 'package:ChatApp/providers/edit_profile_provider.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/view/screens/home_page.dart';
import 'package:ChatApp/view/widgets/custom_progress_indicator.dart';
import 'package:ChatApp/view/widgets/submit_button.dart';

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
  User? myUser;

  @override
  void initState() {
    super.initState();
    myUser = Provider.of<UserProvider>(context, listen: false).myUser;
    loadData();
  }

  loadData() {
    bioController.text = myUser!.userSpec!.bio;
    usernameController.text = myUser!.userSpec!.username;
  }

  @override
  void dispose() {
    usernameController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<EditProfileProvider>(builder: (context, provider, _) {
        return Scaffold(
          body: provider.isLoading == true
              ? CustomProgressIndicator()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 4.0.h),
                      Center(
                        child: Stack(
                          children: [
                            provider.file == null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50.5.h),
                                    child: CachedNetworkImage(
                                      height: 45.0.h,
                                      width: 45.0.h,
                                      fit: BoxFit.cover,
                                      imageUrl: myUser!.userSpec!.photo,
                                      placeholder: (context, url) =>
                                          CustomProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ))
                                : CircleAvatar(
                                    radius: 100.0.sp,
                                    backgroundImage:
                                        (FileImage(provider.file!)),
                                  ),
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
                                  Provider.of<EditProfileProvider>(context,
                                          listen: false)
                                      .selectImage(context);
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
                                      style: myGoogleFont(Colors.black, 12.0.sp,
                                          FontWeight.w600),
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
                                      style: myGoogleFont(Colors.black, 12.5.sp,
                                          FontWeight.w600),
                                      validator: (val) {
                                        if (val!.trim().length > 100)
                                          return 'Bio is too long';
                                        else
                                          return null;
                                      },
                                      controller: bioController,
                                      decoration: InputDecoration(
                                          hintText: 'Update bio'),
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Provider.of<EditProfileProvider>(context,
                                          listen: false)
                                      .handleSubmit(
                                          bio: bioController.text,
                                          context: context,
                                          formKey: formKey,
                                          username: usernameController.text);
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
      }),
    );
  }
}
