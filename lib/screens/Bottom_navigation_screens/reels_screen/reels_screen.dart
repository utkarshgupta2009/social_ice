import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:social_ice/models/video_information_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/reels_screen/reel_controller.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/widgets/reels_screen_widget/reels_item.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelScreenState();
}

class _ReelScreenState extends State<ReelsScreen> {
  final reelsController = Get.put(ReelController());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseServices.firestore
            .collection('reels')
            .where("userId", isNotEqualTo: FirebaseServices.auth.currentUser?.uid)
            .orderBy('publishesDateTime', descending: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(child: Text('Loading...'));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No reels to show'));
            } else {
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
                  final String videoId = snapshot.data!.docs[index].data()["videoId"].toString();
                  final String userId = snapshot.data!.docs[index].data()["userId"].toString();
                  return FutureBuilder(
                    future: FirebaseServices().getVideoDetails(userId, videoId),
                    builder: (context, snapshotVideoData) {
                      if (snapshotVideoData.connectionState == ConnectionState.none) {
                        return const Center(child: Text('Loading...'));
                      } else if (snapshotVideoData.hasError) {
                        return Center(child: Text('Error: ${snapshotVideoData.error}'));
                      } else if (snapshotVideoData.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshotVideoData.connectionState == ConnectionState.active || snapshotVideoData.connectionState == ConnectionState.done) {
                        VideoInformationModel videoData = snapshotVideoData.data as VideoInformationModel;
                        return ReelsItem(videoData);
                      } else {
                        return const Center(child: Text('Something went wrong'));
                      }
                    },
                  );
                },
              );
            }
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
