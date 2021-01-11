import 'package:ChatApp/constants.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hint;
  final Color filledColor;
  final bool obs;
  final Function vald;
  TextEditingController controller = TextEditingController();

  MyTextField(
      [this.hint, this.filledColor, this.obs, this.controller, this.vald]);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: vald,
      controller: controller,
      obscureText: obs == true ? true : false,
      decoration: InputDecoration(
          fillColor: Colors.grey[100],
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1)),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent, width: 1)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1)),
          errorStyle: myGoogleFont(Colors.red, 14, FontWeight.w500)),
    );
  }
}
