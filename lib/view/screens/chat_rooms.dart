import 'package:ChatApp/constants.dart';
import 'package:ChatApp/data/models/user.dart';
import 'package:ChatApp/data/services/auth_services.dart';
import 'package:ChatApp/providers/chat_rooms_provider.dart';
import 'package:ChatApp/providers/user_provider.dart';
import 'package:ChatApp/view/screens/home_layout_screen.dart';
import 'package:ChatApp/view/screens/user_profile.dart';
import 'package:ChatApp/view/screens/splash_screen.dart';
import 'package:ChatApp/data/services/shared_pref.dart';
import 'package:ChatApp/data/services/user_suggestion.dart';
import 'package:ChatApp/view/widgets/custom_error_widget.dart';
import 'package:ChatApp/view/widgets/custom_progress_indicator.dart';
import 'package:ChatApp/view/widgets/user_tile.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  TextEditingController searchController = TextEditingController();
  late UserSuggestion userSuggestion;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String? userId;
  AuthServices authServices = AuthServices();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    String currentUserId =
        Provider.of<UserProvider>(context, listen: false).myUser!.uid!;
    userSuggestion = UserSuggestion(currentUserId);
    Provider.of<ChatRoomsProvider>(context, listen: false)
        .getUserRoomsList(currentUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Column(
          children: [
            Container(
              height: 13.5.h,
              child: Padding(
                padding: EdgeInsets.only(left: 12.5.w, right: 8.25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.8.h, horizontal: 2.25.w),
                          child: Consumer<ChatRoomsProvider>(
                              builder: (context, provider, _) {
                            return Text(
                              '${provider.userRoomsList?.length ?? 5}',
                              style: myGoogleFont(
                                  Colors.white, 10.5.sp, FontWeight.w500),
                            );
                          }),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(15.0.sp)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 3.25.w, right: 1.5.w, top: 0.5.h),
                          child: Text(
                            'Chats',
                            style: myGoogleFont(
                                Colors.black, 13.8.sp, FontWeight.w500),
                          ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: kGreenColor,
                          size: 23.0.sp,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        authServices.showLogoutDialouge(context, scaffoldKey);
                      },
                      icon: Icon(
                        Icons.exit_to_app_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: (1 / 6.7).h,
              width: double.infinity,
              color: Colors.grey[200],
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                child: TypeAheadField<User?>(
                  suggestionsCallback: userSuggestion.getUserSuggestions,
                  itemBuilder: (context, userSuggestion) {
                    return ListTile(
                      leading: Image.network(userSuggestion!.userSpec!.photo),
                      title: Text(userSuggestion.userSpec!.username),
                    );
                  },
                  onSuggestionSelected: (userSuggestion) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return UserProfile(userSuggestion!);
                    }));
                  },
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1),
                  ),
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: searchController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: kGreenColor,
                          size: 22.0.sp,
                        ),
                        hintText: 'Search',
                        hintStyle: myGoogleFont(
                            Colors.black, 13.5.sp, FontWeight.w500),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                )),
            Expanded(
              child: Consumer<ChatRoomsProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading)
                    return CustomProgressIndicator();
                  else if (provider.userRoomsList == null)
                    return CustomErrorWidget('An error occured');
                  else if (provider.userRoomsList!.isEmpty)
                    return CustomErrorWidget(
                        "You haven't followed any users yet");
                  else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        String currentUserId =
                            Provider.of<UserProvider>(context, listen: false)
                                .myUser!
                                .uid!;
                        Provider.of<ChatRoomsProvider>(context, listen: false)
                            .getUserRoomsList(currentUserId);
                        return Future.delayed(
                          Duration(seconds: 0),
                        );
                      },
                      child: ListView.builder(
                        itemCount: provider.userRoomsList!.length,
                        itemBuilder: (context, index) {
                          return UserTile(provider.userRoomsList![index]);
                        },
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
