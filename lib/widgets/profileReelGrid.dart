import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:social_ice/models/video_information_model.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/widgets/profileReelGridItem.dart';

class ProfileReelGrid extends StatelessWidget {
  final String userId;
  const ProfileReelGrid({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseServices.firestore
            .collection("users")
            .doc(userId)
            .collection("reels")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No reels uploaded"),
            );
          } else if (snapshot.hasData) {
            return GridView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2,
                    mainAxisExtent: Get.height * 0.23,
                    crossAxisCount: 3,
                    crossAxisSpacing: 6),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  } else {
                    return FutureBuilder(
                        future: FirebaseServices().getVideoDetails(
                            userId, snapshot.data!.docs[index].id),
                        builder: (context, videoDetails) {
                          VideoInformationModel videoData =
                              videoDetails.data as VideoInformationModel;
                          return profileReelGridItem(
                            videoData,
                            index: index,
                          );
                        });
                  }
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
