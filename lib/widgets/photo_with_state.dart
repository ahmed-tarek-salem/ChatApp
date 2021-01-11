import 'package:ChatApp/constants.dart';
import 'package:flutter/material.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class PhotoWithState extends StatefulWidget {
  final bool state;
  final String photoUrl;
  final double radius;
  final double radiusOfBall;
  final Color colorOfBall;
  PhotoWithState(
      {this.photoUrl,
      this.radius,
      this.state,
      this.radiusOfBall,
      this.colorOfBall});

  @override
  _PhotoWithStateState createState() => _PhotoWithStateState();
}

class _PhotoWithStateState extends State<PhotoWithState> {
  // @override
  // void dispose() {
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: widget.radius,
          // backgroundImage: NetworkImage(
          //   widget.photoUrl,
          // ),
          backgroundImage: OptimizedCacheImageProvider(widget.photoUrl,
              cacheHeight: 50, cacheWidth: 50),
        ),
        // CircleAvatar(
        //   radius: widget.radius,
        //   backgroundImage: CachedNetworkImageProvider(
        //     widget.photoUrl,

        //     ),
        // ),
        Positioned(
            right: -3,
            bottom: 0,
            child: CircleAvatar(
              backgroundColor: widget.colorOfBall,
              radius: widget.radiusOfBall + 3,
              child: CircleAvatar(
                  radius: widget.radiusOfBall,
                  backgroundColor:
                      widget.state == true ? kGreenColor : Colors.grey[300]),
            ))
      ],
    );
  }
}
