import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/utils/cachedImage.dart';
import 'package:social_ice/utils/uploadMedia.dart';
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
  //int videoCount = await FirebaseServices().getVideoCount(userData.uid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(top: Get.height*0.01,left: Get.height*0.01,right: Get.height*0.01,),
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
                                      titleText: "20",
                                      subtitleText: "Posts"),
                                  SizedBox(
                                    width: Get.width * 0.07,
                                  ),
                                  const UserProfileRowWidget(
                                      titleText: "200",
                                      subtitleText: "Followers"),
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
                                  padding:
                                      EdgeInsets.only(left: Get.width * 0.07),
                                  child: Text(
                                    "@${widget.userData.username.toString()}",
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 240, 237, 234),
                                        fontSize: Get.height * 0.018),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(Get.height * 0.02),
                              child: SizedBox(
                                height: Get.height * 0.05,
                                width: Get.width * 0.4,
                                child: MaterialButton(
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
                                        contentPadding:
                                            const EdgeInsets.all(20));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color:
                                      const Color.fromARGB(255, 249, 126, 38),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "upload new reel",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 246, 233, 221),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        Icons.cloud_upload_outlined,
                                        color: const Color.fromARGB(
                                            255, 246, 233, 221),
                                        size: Get.height * 0.023,
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
                                      color: const Color.fromARGB(
                                          255, 240, 237, 234),
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
                            padding:  EdgeInsets.symmetric(horizontal:Get.width*0.03, vertical: Get.height*0.01),
                            child: ProfileReelGrid(user: widget.userData),
                          ),
                        ],
                      )
                    ],
                  ));
  }
}
