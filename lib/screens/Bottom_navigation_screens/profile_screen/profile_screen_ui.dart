import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/profile_screen/user_profile_controller.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/utils/cachedImage.dart';
import 'package:social_ice/utils/uploadMedia.dart';
import 'package:social_ice/widgets/app_button.dart';
import 'package:social_ice/widgets/profileReelGrid.dart';
import 'package:social_ice/widgets/user_profile_row_widget.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userData;
  const ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final uploadReelController = Get.put(UploadMediaController());
  final profileController = Get.put(userProfileController());
  //int videoCount = await FirebaseServices().getVideoCount(userData.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.userData.uid != FirebaseServices.auth.currentUser?.uid
            ? AppBar(
                title: Text(widget.userData.name.toString()),
              )
            : null,
        body: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Get.height * 0.01,
                left: Get.height * 0.01,
                right: Get.height * 0.01,
              ),
              child: Container(
                height: Get.height * 0.28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: Get.height * 0.01,
                                  left: Get.height * 0.01),
                              child: ClipOval(
                                child: SizedBox(
                                  height: Get.height * 0.1,
                                  width: Get.height * 0.1,
                                  child: CachedImage(
                                      widget.userData.profilePicUrl),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: Get.width * 0.07,
                        ),
                        const UserProfileRowWidget(
                            titleText: "20", subtitleText: "Posts"),
                        SizedBox(
                          width: Get.width * 0.07,
                        ),
                        const UserProfileRowWidget(
                            titleText: "200", subtitleText: "Followers"),
                        SizedBox(
                          width: Get.width * 0.07,
                        ),
                        const UserProfileRowWidget(
                            titleText: "100", subtitleText: "Following"),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: Get.width * 0.07),
                        child: Text(
                          "@${widget.userData.username}",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 240, 237, 234),
                              fontSize: Get.height * 0.018),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                  widget.userData.uid == FirebaseServices.auth.currentUser?.uid
                      ? AppButton(
                          onPressed: () {
                            Get.defaultDialog(
                                title: "Choose an option to continue",
                                titleStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                titlePadding: const EdgeInsets.all(20),
                                middleText: "Upload video from",
                                middleTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                textCancel: "gallery",
                                textConfirm: "camera",
                                onConfirm: () {
                                  uploadReelController
                                      .getVideo(ImageSource.camera);
                                  Get.back();
                                },
                                onCancel: () {
                                  uploadReelController
                                      .getVideo(ImageSource.gallery);
                                  Get.back();
                                },
                                contentPadding: const EdgeInsets.all(20));
                          },
                          buttonLabel: "Upload new reel",
                          textColor: Colors.black,
                          color: Colors.white,
                        )
                      : Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: SizedBox(
                                    width: Get.width * 0.5,
                                    child: FutureBuilder(
                                        future: FirebaseServices()
                                            .checkIfFollowing(
                                                widget.userData.uid as String),
                                        builder: (context, snapshot) {
                                          return AppButton(
                                            onPressed: () async {
                                              setState(() {
                                                if (snapshot.data == true) {
                                                FirebaseServices().unfollowUser(
                                                    widget.userData);
                                              } else {
                                                FirebaseServices().followUser(
                                                    widget.userData);
                                              }
                                              });
                                            },
                                            buttonLabel: snapshot.data == false
                                                ? "Follow"
                                                : "Unfollow",
                                            color: Colors.white,
                                            textColor: Colors.black,
                                          );
                                        }))),
                            Flexible(
                                flex: 1,
                                child: SizedBox(
                                  width: Get.width * 0.5,
                                  child: AppButton(
                                    onPressed: () {},
                                    buttonLabel: "Message",
                                    color: Colors.white,
                                    textColor: Colors.black,
                                  ),
                                )),
                          ],
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.grid_on,
                        color: Color.fromARGB(255, 240, 237, 234),
                      ),
                      Text(
                        "  REELS",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 240, 237, 234),
                            fontSize: Get.height * 0.018),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.03,
                      vertical: Get.height * 0.01),
                  child: ProfileReelGrid(userId: widget.userData.uid),
                ),
              ],
            )
          ],
        ));
  }
}
