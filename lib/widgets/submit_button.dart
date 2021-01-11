import 'package:ChatApp/constants.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String myLabel;
  final Color myColor;
  SubmitButton(this.myLabel, {this.myColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: myColor == null ? kGreenColor : Colors.grey[400],
          borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          myLabel,
          style: myGoogleFont(Colors.white, 20, FontWeight.w500),
        ),
      ),
    );
  }
}
