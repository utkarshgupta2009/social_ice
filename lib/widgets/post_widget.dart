import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/post_information_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/profile_screen/profile_screen_builder.dart';
import 'package:social_ice/widgets/video_player_widget.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;

  PostWidget({required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height * 0.01),
      child: Container(
        //padding: EdgeInsets.all(Get.height * 0.018),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(ProfileScreenBuilder(
                        uid: widget.post.userId.toString()));
                  },
                  child: CircleAvatar(
                    radius: Get.height * 0.03, // Adjust as per your requirement
                    backgroundImage:
                        NetworkImage(widget.post.userProfileImageUrl ?? ""),
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  widget.post.username ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: widget.post.mediaType == MediaType.image
                  ? Image.network(
                      widget.post.mediaUrl.toString(),
                      fit: BoxFit.fill,
                    )
                  : CustomVideoPlayer(
                      videoUrl: widget.post.mediaUrl.toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    // Handle like button tap
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    // Handle comment button tap
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    // Handle share button tap
                  },
                ),
              ],
            ),
            Text(
              widget.post.caption ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
