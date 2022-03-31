import 'package:ChatApp/view/widgets/custom_progress_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullImageScreen extends StatelessWidget {
  final String? photoUrl;
  FullImageScreen(this.photoUrl);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CachedNetworkImage(
          imageUrl: photoUrl!,
          placeholder: (context, url) => CustomProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          maxHeightDiskCache: 300,
          maxWidthDiskCache: 300,
        ),
      ),
    );
  }
}
