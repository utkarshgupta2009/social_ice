import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/screens/bottom_navigation_screens/new_post_screen/selecting_post_screen/VideoProvider.dart';
import 'package:social_ice/screens/bottom_navigation_screens/new_post_screen/selecting_post_screen/new_post_controller.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final controller = Get.put(NewPostController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    height: Get.height * 0.5,
                    width: Get.width,
                    clipBehavior: Clip.hardEdge,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: controller.mediumType.value == 'image'
                        ? Image.file(
                            File(controller.selectedPostPath.value),
                            fit: BoxFit.fill,
                          )
                        : VideoProvider(mediumId: controller.mediumId.value))),
          )
        ],
      ),
    );
  }
}
