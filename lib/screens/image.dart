import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String? photoUrl;
  ImageScreen(this.photoUrl);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image(
          image: NetworkImage(photoUrl!),
        ),
      ),
    );
  }
}
