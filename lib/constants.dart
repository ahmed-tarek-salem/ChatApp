import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color kGreenColor = Color(0xff58DC84);

TextStyle myGoogleFont(
    Color? textColor, double myfontSize, FontWeight fontWeight,
    {double? letterSpacing}) {
  return GoogleFonts.montserrat(
      textStyle: TextStyle(
          color: textColor,
          fontSize: myfontSize,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing == null ? 0.3 : letterSpacing));
}
clearCash(){
  PaintingBinding.instance!.imageCache!.clear();
PaintingBinding.instance!.imageCache!.clearLiveImages();
}