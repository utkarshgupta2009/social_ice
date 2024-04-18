import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/utils/cachedImage.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelsItem extends StatefulWidget {
  final snapshot;
  ReelsItem(this.snapshot, {super.key});

  @override
  State<ReelsItem> createState() => _ReelsItemState();
}

class _ReelsItemState extends State<ReelsItem> {
  VideoPlayerController? controller;
  bool play = true;
  bool isPlayingNotifier = false;

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
    return Scaffold(
      body: VisibilityDetector(
        key: Key(widget.snapshot["videoUrl"]),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (mounted) {
            if (controller!.value.isInitialized) {
              if (visiblePercentage > 50) {
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
                  play = !play;
                });
                if (play) {
                  controller!.play();
                } else {
                  controller!.pause();
                }
              },
              child: Container(
                color: Colors.black,
                width: double.infinity,
                height:double.infinity,
                child: Center(
                  child: Container(
                    height: Get.height*0.85,
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
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(45, 0, 0, 0),
                        blurRadius: 25,
                        blurStyle: BlurStyle.normal
                      )
                    ]
                  ),
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
              bottom: Get.height * 0.02,
              left: Get.width*0.03,
              right: Get.width*0.13,
              child: Container(
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(75, 0, 0, 0),
                        blurRadius: 30,
                        blurStyle: BlurStyle.normal
                      )]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: SizedBox(
                            height: Get.height * 0.05,
                            width: Get.height * 0.05,
                            child:
                                CachedImage(widget.snapshot['userProfileImageUrl']),
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
                    SizedBox(height: Get.height * 0.015),
                    ExpandableText(
                      widget.snapshot['caption'],
                      style: TextStyle(
                        fontSize: Get.pixelRatio * 6,
                        color: Colors.white,
                      ), expandText: 'more',
                     collapseOnTextTap: true,
                     expandOnTextTap: true,
                     animation: true,
                     animationDuration: Durations.medium3,
                     animationCurve: Curves.easeIn,
                      
                     
                    ),
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
