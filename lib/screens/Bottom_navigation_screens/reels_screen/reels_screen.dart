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
          if (snapshot.connectionState == ConnectionState.none) {
            // If the future has not been initialized yet, display a placeholder
            return const Center(child: Text('Loading...'));
          } else if (snapshot.hasError) {
            // If there is an error while fetching data, display the error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // If the future is still waiting for data, display a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            // If the future has completed with data or is actively receiving updates

            if (snapshot.data!.docs.isEmpty) {
              // If there are no posts, display a message
              return const Center(child: Text('No posts to show'));
            } else {
              // If there are posts, build the ListView
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
                        VideoInformationModel videoData =
                            snapshot.data as VideoInformationModel;
                        return ReelsItem(videoData);
                      });
                },
              );
            }
          } else {
            // If the connection state is not covered by any of the above cases
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
