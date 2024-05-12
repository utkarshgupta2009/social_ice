import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:social_ice/models/video_information_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/reels_screen/reel_controller.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/widgets/reels_item.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelsScreen> {
  final reelsController = Get.put(ReelController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseServices.firestore
            .collection('reels')
            .where("userId",
                isNotEqualTo: FirebaseServices.auth.currentUser?.uid)
            .orderBy('publishesDateTime', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No reels to show"),
              );
            } else if (snapshot.hasData) {
              return PreloadPageView.builder(
                preloadPagesCount: 5,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: PreloadPageController(
                  initialPage: 0,
                  viewportFraction: 1,
                ),
                onPageChanged: (value) {
                  reelsController.isCaptionTapped.value = false;
                },
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final String videoId =
                      snapshot.data!.docs[index].data()["videoId"].toString();
                  final String userId =
                      snapshot.data!.docs[index].data()["userId"].toString();
                  return FutureBuilder(
                      future:
                          FirebaseServices().getVideoDetails(userId, videoId),
                      builder: (context, snapshot) {
                        return ReelsItem(
                            snapshot.data as VideoInformationModel);
                      });
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
