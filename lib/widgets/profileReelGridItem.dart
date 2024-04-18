// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/widgets/reels_item.dart';

class profileReelGridItem extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snapshot;
  final int index;
  const profileReelGridItem(this.snapshot, {super.key, required this.index});

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
          height: Get.height*0.4,
          width: Get.width*0.4,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            child: GestureDetector(
              child: Image.network(
                widget.snapshot["thumbnailUrl"],
                fit: BoxFit.fill,
              ),
              onTap: () {
                Get.to(ReelsItem(widget.snapshot));
              },
            )),
            // Positioned(
            //   top: Get.height*0.19, 
            //   child:const Row(
            //     children: [
            //       Icon(Icons.play_arrow_outlined,
            //       color: Colors.white,),
            //       Text("20",
            //       style: TextStyle(
            //         color: Colors.white
            //       ),)
            //     ],
            //   ))
      ]),
    );
  }
}
