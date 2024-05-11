import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoProvider extends StatefulWidget {
  /// The identifier of medium
  final String mediumId;

  /// The constructor of VideoProvider
  const VideoProvider({
    required this.mediumId,
  });

  @override
  _VideoProviderState createState() => _VideoProviderState();
}

class _VideoProviderState extends State<VideoProvider> {
  VideoPlayerController? _controller;
  File? _file;
  bool isTapped = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
    super.initState();
  }

  Future<void> initAsync() async {
    try {
      _file = await PhotoGallery.getFile(mediumId: widget.mediumId);
      _controller = VideoPlayerController.file(_file!);
      _controller?.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller!.play();
          _controller!.setLooping(true);
        });
      });
    } catch (e) {
      print("Failed : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null || !_controller!.value.isInitialized
        ? Container()
        : Container(
            height: Get.height * 0.43,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isTapped = !isTapped;

                  if (isTapped) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                });
              },
              child: Stack(
                children: [
                  VisibilityDetector(
                    key: Key(widget.mediumId),
                    child: VideoPlayer(
                      _controller!,
                      key: Key(widget.mediumId),
                    ),
                    onVisibilityChanged: (visibilityInfo) {
                      var visiblePercentage =
                          visibilityInfo.visibleFraction * 100;
                      if (mounted) {
                        if (_controller!.value.isInitialized) {
                          if (visiblePercentage == 100) {
                            _controller!.play();
                          } else {
                            _controller!
                                .seekTo(const Duration(milliseconds: 0));
                            _controller!.pause();
                            if (isTapped) {
                              setState(() {
                                isTapped = !isTapped;
                              });
                            }
                          }
                        }
                      }
                    },
                  ),
                  if (isTapped)
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
                ],
              ),
            ),
          );
  }
}
