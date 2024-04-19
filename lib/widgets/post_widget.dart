import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/post_information_model.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;

  PostWidget({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(Get.height*0.01),
      child: Container(
        padding: EdgeInsets.all(Get.height*0.018),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 251, 226, 201),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: Get.height * 0.03, // Adjust as per your requirement
                  backgroundImage: NetworkImage(post.userProfileImageUrl ?? ""),
                ),
                SizedBox(width: 10.0),
                Text(
                  post.username ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
                
              ),
              child: Image.network(
                post.imageUrl ?? "",
                height: Get.height * 0.4, // Adjust as per your requirement
                width: Get.width, // Takes full width of the screen
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    // Handle like button tap
                  },
                ),
                IconButton(
                  icon: Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    // Handle comment button tap
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    // Handle share button tap
                  },
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              post.caption ?? "",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
