// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/video_information_model.dart';
import 'package:social_ice/widgets/reels_item.dart';

class profileReelGridItem extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final VideoInformationModel videoData;
  final int index;
  const profileReelGridItem(this.videoData, {super.key, required this.index});

  @override
  State<profileReelGridItem> createState() => _profileReelGridItemState();
}

class _profileReelGridItemState extends State<profileReelGridItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Get.height * 0.004),
      child: Stack(children: [
        Container(
            height: Get.height * 0.4,
            width: Get.width * 0.4,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: GestureDetector(
              child: Image.network(
                widget.videoData.thumbnailUrl.toString(),
                fit: BoxFit.fill,
              ),
              onTap: () {
                Get.to(ReelsItem(widget.videoData));
              },
            )),
      ]),
    );
  }
}
