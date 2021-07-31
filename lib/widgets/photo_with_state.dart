import 'package:ChatApp/constants.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sizer/sizer.dart';

class PhotoWithState extends StatefulWidget {
  final bool? state;
  final String? photoUrl;
  final double? radius;
  final double? radiusOfBall;
  final Color? colorOfBall;
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
        // ClipOval(
        //   child:
        //       CachedNetworkImage(imageUrl: widget.photoUrl!, fit: BoxFit.cover),
        // ),
//         Container(
//           width: 8.5.h,
//           height: 8.5.h,

//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: DecorationImage(
//               fit: BoxFit.cover,
//               image: CachedNetworkImageProvider(
//                 widget.photoUrl!,
//                 maxHeight: 80,
//                 maxWidth: 80,
// ),

//             ),
//           ),
//         ),
        ClipRRect(
          borderRadius: BorderRadius.circular(50.5.h),
          child: CachedNetworkImage(
            height: widget.radius,
            width: widget.radius,
            fit: BoxFit.cover,
            imageUrl: widget.photoUrl!,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            maxHeightDiskCache: 80,
            maxWidthDiskCache: 80,
          ),
        ),
        // CircleAvatar(
        //   radius: widget.radius,
        //   backgroundImage: CachedNetworkImageProvider(
        //     widget.photoUrl!,
        //   ),
        // ),
        Positioned(
          right: -3,
          bottom: 0,
          child: CircleAvatar(
            backgroundColor: widget.colorOfBall,
            radius: widget.radiusOfBall! + 3.5,
            child: CircleAvatar(
                radius: widget.radiusOfBall,
                backgroundColor:
                    widget.state == true ? kGreenColor : Colors.grey[300]),
          ),
        )
      ],
    );
  }
}
