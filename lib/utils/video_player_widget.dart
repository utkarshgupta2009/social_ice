import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;

  CustomVideoPlayer({required this.videoUrl});

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool isTapped = false;
  bool isInitializing = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized

        setState(() {
          isInitializing = false;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() {
        isTapped = !isTapped;
      });
    } else {
      _controller.play();
      setState(() {
        isTapped = !isTapped;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          VideoPlayer(_controller),
          if (!isTapped && !isInitializing)
            const Icon(
              Icons.play_arrow,
              size: 50,
              color: Colors.white,
            ),
            if (isInitializing)
          const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
