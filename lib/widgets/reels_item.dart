import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/video_information_model.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/profile_screen/profile_screen_ui.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/reels_screen/reel_controller.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/utils/cachedImage.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelsItem extends StatefulWidget {
  final VideoInformationModel videoData;
  ReelsItem(this.videoData, {super.key});

  @override
  State<ReelsItem> createState() => _ReelsItemState();
}

class _ReelsItemState extends State<ReelsItem> {
  VideoPlayerController? controller;
  bool play = true;
  bool isPlayingNotifier = false;
  final reelController = Get.put(ReelController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ignore: deprecated_member_use
   // final String path = widget.videoData.videoUrl[]
    Uri uri = Uri.parse(widget.videoData.videoUrl.toString());
    controller = VideoPlayerController.networkUrl(uri)
      ..initialize().then((value) {
        setState(() {
          controller!.setLooping(true);
          controller!.setVolume(1);
          //controller!.play();
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int captionWordCount =
        widget.videoData.caption.toString().split(" ").length;

    return Scaffold(
      body: VisibilityDetector(
        key: Key(widget.videoData.videoUrl.toString()),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (mounted) {
            if (controller!.value.isInitialized) {
              if (visiblePercentage >= 50) {
                controller!.play();
              } else {
                controller!.seekTo(const Duration(milliseconds: 0));
                controller!.pause();
                if (!play) {
                  setState(() {
                    play = !play;
                  });
                }
              }
              setState(() {
                isPlayingNotifier = true;
              });
            }
          }
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if ((reelController.isCaptionTapped.value && play) ||
                      (reelController.isCaptionTapped.value && !play)) {
                    reelController.isCaptionTapped.value =
                        !reelController.isCaptionTapped.value;
                  } else {
                    play = !play;
                  }
                });
                if (play) {
                  controller!.play();
                } else {
                  controller!.pause();
                }
              },
              onLongPress: () {
                setState(() {
                  if (play) {
                    play = !play;
                    controller!.pause();
                  }
                });
              },
              onLongPressUp: () {
                setState(() {
                  play = !play;
                  controller!.play();
                });
              },
              child: Container(
                color: Colors.black,
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: SizedBox(
                    height: double.infinity,
                    child: SizedBox(
                      height: controller!.value.size.height,
                      child: VideoPlayer(controller!),
                    ),
                  ),
                ),
              ),
            ),
            if (!play)
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white30,
                  radius: Get.height * 0.03,
                  child: Icon(
                    Icons.play_arrow,
                    size: Get.height * 0.03,
                    color: Colors.white,
                  ),
                ),
              ),
            Positioned(
                top: Get.height * 0.55,
                left: Get.width * 0.85,
                child: Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(45, 0, 0, 0),
                        blurRadius: 25,
                        blurStyle: BlurStyle.normal)
                  ]),
                  child: Column(children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: Get.pixelRatio * 12,
                      ),
                    ),
                    Text(
                      widget.videoData.totalLikes.toString(),
                      style: TextStyle(
                        fontSize: Get.pixelRatio * 6,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.comment_rounded,
                        color: Colors.white,
                        size: Get.pixelRatio * 12,
                      ),
                    ),
                    Text(
                      widget.videoData.totalComments.toString(),
                      style: TextStyle(
                        fontSize: Get.pixelRatio * 6,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.01),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.share_rounded,
                        color: Colors.white,
                        size: Get.pixelRatio * 12,
                      ),
                    ),
                  ]),
                )),
            Positioned(
              bottom: 3,
              left: Get.width * 0.03,
              right: Get.width * 0.03,
              child: Container(
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Color.fromARGB(88, 0, 0, 0),
                      blurRadius: 30,
                      blurStyle: BlurStyle.normal,
                      spreadRadius: 30)
                ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final userData = await FirebaseServices()
                            .getUserDetails(widget.videoData.userId.toString());
                        Get.to(ProfileScreen(userData: userData));
                      },
                      child: Row(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              height: Get.height * 0.05,
                              width: Get.height * 0.05,
                              child: CachedImage(
                                  widget.videoData.userProfileImageUrl),
                            ),
                          ),
                          SizedBox(width: Get.width * 0.03),
                          Text(
                            "@${widget.videoData.username}",
                            style: TextStyle(
                              fontSize: Get.pixelRatio * 6,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: Get.width * 0.03),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height * 0.015),
                    Obx(() {
                      if (reelController.isCaptionTapped.isTrue) {
                        return GestureDetector(
                            onTap: () =>
                                reelController.isCaptionTapped.value = false,
                            child: captionWordCount > 95
                                ? AnimatedContainer(
                                    duration: Durations.extralong1,
                                    curve: Curves.easeIn,
                                    height: Get.height * 0.4,
                                    width: Get.width * 0.8,
                                    child: ListView(
                                      children: [
                                        Text(
                                          widget.videoData.caption.toString(),
                                          style: TextStyle(
                                            fontSize: Get.pixelRatio * 6,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    width: Get.width * 0.8,
                                    child: Text(
                                      widget.videoData.caption.toString(),
                                      style: TextStyle(
                                        fontSize: Get.pixelRatio * 6,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ));
                      } else {
                        return GestureDetector(
                          onTap: () {
                            if (captionWordCount > 20) {
                              reelController.isCaptionTapped.value = true;
                            }
                          },
                          child: SizedBox(
                            width: Get.width * 0.8,
                            child: Text(
                              widget.videoData.caption.toString(),
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: Get.pixelRatio * 6,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                    })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
