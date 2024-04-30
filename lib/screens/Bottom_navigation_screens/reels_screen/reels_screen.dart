import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:social_ice/models/video_information_model.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/reels_screen/reel_controller.dart';
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
      body: StreamBuilder(
        stream: FirebaseServices.firestore
            .collection('reels')
            .orderBy('publishesDateTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.data!.docs.isEmpty
              ? const Center(
                  child: Text("NO REELS UPLOADED."),
                )
              : PreloadPageView.builder(
                  preloadPagesCount: 5,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: PreloadPageController(
                    initialPage: 0,
                    viewportFraction: 1,
                  ),
                  onPageChanged: (value) {
                    reelsController.isCaptionTapped.value = false;
                  },
                  itemCount:
                      snapshot.data == null ? 0 : snapshot.data!.docs.length,
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
        },
      ),
    );
  }
}
