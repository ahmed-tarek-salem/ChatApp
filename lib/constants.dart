import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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

clearCash() {
  PaintingBinding.instance!.imageCache!.clear();
  PaintingBinding.instance!.imageCache!.clearLiveImages();
}

returnNameOfChat(String name1, String name2) {
  int lengthOfSmallerEmail = [name1.length, name2.length].reduce(min);
  for (int i = 0; i < lengthOfSmallerEmail; i++) {
    if (name1[i].codeUnitAt(0) < name2[i].codeUnitAt(0)) {
      return '$name1 _ $name2'.trim();
    } else if (name1[i].codeUnitAt(0) > name2[i].codeUnitAt(0)) {
      return '$name2 _ $name1'.trim();
    }
  }
  return '$name1 _ $name2'.trim();
}

Future<String> getCurrentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  Placemark placemark = placemarks[0];
  String formattedPlace = '${placemark.locality} , ${placemark.country}';
  return formattedPlace;
}
