import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final Color myColor;
  final String myTitle;
  final Color titleColor;
  CustomButton(this.myColor, this.myTitle, this.titleColor);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 8.0.h,
      margin: EdgeInsets.symmetric(horizontal: 12.5.w),
      decoration: BoxDecoration(
        color: myColor,
        borderRadius: BorderRadius.circular(30.0.sp),
      ),
      child: Center(
        child: Text(
          myTitle,
          style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                  fontSize: 15.0.sp,
                  color: titleColor,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
