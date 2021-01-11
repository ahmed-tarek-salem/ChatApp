import 'package:flutter/material.dart';
import 'package:optimized_cached_image/image_provider/optimized_cached_image_provider.dart';

class ImageScreen extends StatelessWidget {
  final String photoUrl;
  ImageScreen(this.photoUrl);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
      child: Image(
        image: OptimizedCacheImageProvider(photoUrl),
      ),
      ),
    );
  }
}