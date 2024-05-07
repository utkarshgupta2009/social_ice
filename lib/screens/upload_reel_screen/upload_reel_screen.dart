import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/screens/bottom_navigation_screens/reels_screen/reels_screen.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/utils/uploadMedia.dart';
import 'package:social_ice/widgets/app_button.dart';
import 'package:social_ice/widgets/my_text_field.dart';
import 'package:video_player/video_player.dart';

class UploadReelScreen extends StatefulWidget {
  const UploadReelScreen({super.key});

  @override
  State<UploadReelScreen> createState() => _UploadReelScreenState();
}

class _UploadReelScreenState extends State<UploadReelScreen> {
  final uploadController = Get.put(UploadMediaController());
  VideoPlayerController? playerController;
  @override
  void initState() {
    super.initState();

    setState(() {
      playerController = VideoPlayerController.file(
          File(uploadController.selectedVideoPath.value));
    });

    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(1);
    playerController!.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    playerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController captionController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Container(
                margin: const EdgeInsets.all(20),
                height: Get.height * 0.8,
                width: Get.width,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: VideoPlayer(playerController!)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
              child: MyTextField(
                controller: captionController,
                hintText: "add a caption",
                obscureText: false,
                prefixIcon: const Icon(Icons.closed_caption),
               
              ),
            ),
            AppButton(
                onPressed: () {
                  if (captionController.text.isNotEmpty) {
                    Get.defaultDialog(
                        contentPadding: EdgeInsets.all(20),
                        middleText: " we appreciate your patience",
                        title: "Video is uploading please wait patiently",
                        titleStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        actions: [CircularProgressIndicator()]);
                    FirebaseServices().saveVideoInformationToFireStoreDatabase(
                        uploadController.selectedVideoPath.toString(),
                        captionController.text);
                    setState(() {
                      const ReelsScreen();
                    });
                  } else {
                    Get.defaultDialog(
                        titlePadding: EdgeInsets.all(20),
                        contentPadding: EdgeInsets.all(20),
                        middleText: " Kindly add caption",
                        title: "Video upload unsuccessfull",
                        titleStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        confirm: AppButton(
                            onPressed: () {
                              Get.back();
                            },
                            buttonLabel: "Add Caption"));
                  }
                },
                buttonLabel: "Upload reel")
          ],
        )),
      ),
    );
  }
}
