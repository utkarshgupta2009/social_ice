import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:social_ice/models/video_information_model.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/widgets/profile_screen_widgets/profileReelGridItem.dart';

class ProfileReelGrid extends StatelessWidget {
  final String userId;
  const ProfileReelGrid({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseServices.firestore
          .collection("users")
          .doc(userId)
          .collection("reels")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // If there's an error
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          // If there are no reels uploaded
          return Center(
            child: Text("No reels uploaded"),
          );
        } else {
          // If the data is available
          return GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 2,
              mainAxisExtent: Get.height * 0.23,
              crossAxisCount: 3,
              crossAxisSpacing: 6,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: FirebaseServices().getVideoDetails(
                  userId,
                  snapshot.data!.docs[index].id,
                ),
                builder: (context, videoDetails) {
                  if (videoDetails.connectionState == ConnectionState.waiting) {
                    // While waiting for video details
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (videoDetails.hasError) {
                    // If there's an error fetching video details
                    return Center(
                      child: Text("Error: ${videoDetails.error}"),
                    );
                  } else {
                    // If video details are available
                    VideoInformationModel videoData =
                        videoDetails.data as VideoInformationModel;
                    return profileReelGridItem(
                      videoData,
                      index: index,
                    );
                  }
                },
              );
            },
          );
        }
      },
    );
  }
}
