import 'package:ChatApp/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  const CustomErrorWidget(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: myGoogleFont(Colors.black, 15.sp, FontWeight.bold),
      ),
    );
  }
}
