import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/post_information_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/profile_screen/profile_screen_builder.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/utils/cachedImage.dart';
import 'package:social_ice/widgets/app_widgets/comment_bottom_sheet.dart';
import 'package:social_ice/utils/video_player_widget.dart';

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
            color: const Color.fromARGB(255, 226, 221, 221)),
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
                height: Get.height * 0.4,
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: widget.post.mediaType == MediaType.image
                    ? CachedImage(widget.post.mediaUrl)
                    : CustomVideoPlayer(
                        videoUrl: widget.post.mediaUrl.toString()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FutureBuilder<bool>(
                    future: FirebaseServices().isPostLiked(widget.post.postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // If the future is still waiting for data, display a loading indicator
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // If there is an error while fetching data, display the error message
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        // If the future has completed with data
                        isLiked = snapshot.data!;
                        return IconButton(
                          onPressed: () {
                            if (isLiked) {
                              FirebaseServices()
                                  .unlikePost(widget.post.postId as String);
                              setState(() {
                                // Update the state when the post is unliked
                                isLiked = !isLiked;
                              });
                            } else {
                              FirebaseServices()
                                  .likePost(widget.post.postId as String);
                              setState(() {
                                // Update the state when the post is liked
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
                      } else {
                        // If the connection state is not covered by any of the above cases
                        return const Text('Something went wrong');
                      }
                    },
                  ),
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
