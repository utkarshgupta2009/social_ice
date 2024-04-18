import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


// ignore: must_be_immutable
class CachedImage extends StatelessWidget {
 String? imageURL;
  CachedImage( this.imageURL, {super.key});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageUrl: imageURL!,
      progressIndicatorBuilder: (context, url, progress) {
        return Container(
          child: Padding(
            padding: EdgeInsets.all(Get.height*0.01),
            child: CircularProgressIndicator(
              value: progress.progress,
              color: Colors.black,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) => Container(
        color: Colors.amber,
      ),
    );
  }
}