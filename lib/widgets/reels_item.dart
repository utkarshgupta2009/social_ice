import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/profile_screen/profile_screen_ui.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/reels_screen/reel_controller.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/utils/cachedImage.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelsItem extends StatefulWidget {
  final Map<String,dynamic> snapshot;
  ReelsItem(this.snapshot, {super.key});

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
    controller = VideoPlayerController.network(widget.snapshot['videoUrl'])
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
        widget.snapshot['caption'].toString().split(" ").length;

    return Scaffold(
      body: VisibilityDetector(
        key: Key(widget.snapshot["videoUrl"]),
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
                      widget.snapshot["totalLikes"].toString(),
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
                      widget.snapshot["totalComments"].toString(),
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
                        final snapshot = await FirebaseServices.firestore
                            .collection("users")
                            .doc(widget.snapshot["userId"])
                            .get();
                        Get.to(ProfileScreen(snapshot: snapshot));
                      },
                      child: Row(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              height: Get.height * 0.05,
                              width: Get.height * 0.05,
                              child: CachedImage(
                                  widget.snapshot['userProfileImageUrl']),
                            ),
                          ),
                          SizedBox(width: Get.width * 0.03),
                          Text(
                            "@${widget.snapshot['username']}",
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
                                          widget.snapshot['caption'],
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
                                      widget.snapshot['caption'],
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
                              widget.snapshot['caption'],
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
