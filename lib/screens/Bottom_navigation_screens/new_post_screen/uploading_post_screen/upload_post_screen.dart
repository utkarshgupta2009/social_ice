import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/post_information_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/new_post_screen/selecting_post_screen/VideoProvider.dart';
import 'package:social_ice/screens/bottom_navigation_screens/new_post_screen/selecting_post_screen/new_post_controller.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/utils/resize_image.dart';
import 'package:social_ice/widgets/app_button.dart';
import 'package:social_ice/widgets/expandable_textfield.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({super.key});

  @override
  State<UploadPostScreen> createState() => _UploadPostScreenState();
}

class _UploadPostScreenState extends State<UploadPostScreen> {
  final controller = Get.put(NewPostController());
  final TextEditingController captionController = TextEditingController();
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpandableTextField(
              controller: captionController,
              hintText: "Write a caption",
            ),
          ),
          AppButton(
              onPressed: () async {
                final resizedPostPath = controller.mediumType.value == 'image'
                    ? await resizeImageToSquare(
                        controller.selectedPostPath.value)
                    : controller.selectedPostPath.value;
                final MediumType = controller.mediumType.value == "image"
                    ? MediaType.image
                    : MediaType.video;
                await FirebaseServices().savePostInformationToFireStoreDatabase(
                    resizedPostPath, captionController.text, MediumType);
              },
              buttonLabel: "Upload Post")
        ],
      ),
    );
  }
}
