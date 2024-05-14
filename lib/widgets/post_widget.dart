import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/post_information_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/profile_screen/profile_screen_builder.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/widgets/comment_bottom_sheet.dart';
import 'package:social_ice/widgets/video_player_widget.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;

  PostWidget({required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Get.height * 0.01,
      ),
      child: Container(
        //padding: EdgeInsets.all(Get.height * 0.018),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color.fromARGB(255, 226, 221, 221)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(ProfileScreenBuilder(
                          uid: widget.post.userId.toString()));
                    },
                    child: CircleAvatar(
                      radius:
                          Get.height * 0.028, // Adjust as per your requirement
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
                height: widget.post.mediaType == MediaType.video
                    ? Get.height * 0.4
                    : Image.network(
                        widget.post.mediaUrl.toString(),
                        fit: BoxFit.fill,
                      ).height,
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder(
                      future:
                          FirebaseServices().isPostLiked(widget.post.postId),
                      builder: (context, snapshot) {
                        isLiked = snapshot.data as bool;
                        return IconButton(
                          onPressed: () {
                            if (isLiked) {
                              FirebaseServices()
                                  .unlikePost(widget.post.postId as String);
                              setState(() {
                                isLiked = !isLiked;
                              });
                            } else {
                              FirebaseServices()
                                  .likePost(widget.post.postId as String);
                              setState(() {
                                isLiked = !isLiked;
                              });
                            }
                          },
                          icon: Icon(
                            isLiked
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: isLiked ? Colors.red : null,
                            size: Get.pixelRatio * 12,
                          ),
                        );
                      }),
                  Text(
                    widget.post.totalLikes.toString(),
                    style: TextStyle(
                      fontSize: Get.pixelRatio * 6,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                    child: IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => CommentBottomSheet(),
                        );
                        // Handle comment button tap
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      // Handle share button tap
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                child: Text(
                  widget.post.caption ?? "",
                  style: TextStyle(fontSize: Get.height * 0.018),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
