import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/home_screen/home_screen.dart';
import 'package:social_ice/screens/bottom_navigation_screens/new_post_screen/selecting_post_screen/new_post_screen.dart';
import 'package:social_ice/screens/bottom_navigation_screens/profile_screen/profile_screen_builder.dart';
import 'package:social_ice/screens/bottom_navigation_screens/profile_screen/user_profile_controller.dart';
import 'package:social_ice/screens/bottom_navigation_screens/reels_screen/reels_screen.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/utils/cachedImage.dart';

class BottomNavigatorScreen extends StatefulWidget {
  const BottomNavigatorScreen({super.key});

  @override
  State<BottomNavigatorScreen> createState() => _BottomNavigatorScreenState();
}

class _BottomNavigatorScreenState extends State<BottomNavigatorScreen> {
  final controller = Get.put(userProfileController());
  Widget currentScreen = const HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentScreen,
      bottomNavigationBar: Container(
        width: Get.width,
        decoration: const BoxDecoration(color: Colors.black),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.09, vertical: Get.height * 0.007),
          child: FutureBuilder(
              future: controller.getCurrentUserData(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.hasData) {
                  UserModel user = snapshot.data as UserModel;
                  return GNav(
                      tabBackgroundColor:
                          const Color.fromARGB(54, 158, 158, 158),
                      gap: 5,
                      padding: EdgeInsets.all(Get.height * 0.012),
                      onTabChange: (index) {
                        switch (index) {
                          case 0:
                            setState(() {
                              currentScreen = const HomeScreen();
                            });
                            
                            break;

                          case 1:
                            setState(() {
                              currentScreen = const ReelsScreen();
                            });
                            break;

                          case 2:
                            setState(() {
                              currentScreen = NewPostScreen();
                            });
                            break;

                          case 3:
                            setState(() {
                              currentScreen = ProfileScreenBuilder(
                                uid: FirebaseServices.auth.currentUser!.uid,
                              );
                            });
                            break;
                        }
                      },
                      selectedIndex: 0,
                      tabs: [
                        GButton(
                          icon: Icons.home,
                          text: "Home",
                          textStyle: TextStyle(
                              color: const Color(0xffFF8911),
                              fontWeight: FontWeight.bold,
                              fontSize: Get.height * 0.017),
                          iconSize: Get.height * 0.025,
                          iconActiveColor: const Color(0xffFF8911),
                          iconColor: const Color.fromARGB(255, 241, 219, 187),
                        ),
                        GButton(
                          icon: Icons.video_library,
                          text: "Reels",
                          textStyle: TextStyle(
                              color: const Color(0xffFF8911),
                              fontWeight: FontWeight.bold,
                              fontSize: Get.height * 0.017),
                          iconSize: Get.height * 0.025,
                          iconActiveColor: const Color(0xffFF8911),
                          iconColor: const Color.fromARGB(255, 241, 219, 187),
                        ),
                        GButton(
                          icon: Icons.add_a_photo_rounded,
                          text: "New",
                          textStyle: TextStyle(
                              color: const Color(0xffFF8911),
                              fontWeight: FontWeight.bold,
                              fontSize: Get.height * 0.017),
                          iconSize: Get.height * 0.025,
                          iconActiveColor: const Color(0xffFF8911),
                          iconColor: const Color.fromARGB(255, 241, 219, 187),
                        ),
                        GButton(
                          icon: Icons.account_circle_sharp,
                          leading: ClipOval(
                              child: SizedBox(
                                  height: Get.height * 0.028,
                                  width: Get.height * 0.028,
                                  child: CachedImage(user.profilePicUrl))),
                          text: "Profile",
                          textStyle: TextStyle(
                              color: const Color(0xffFF8911),
                              fontWeight: FontWeight.bold,
                              fontSize: Get.height * 0.017),
                          iconSize: Get.height * 0.025,
                          iconActiveColor: const Color(0xffFF8911),
                          iconColor: const Color.fromARGB(255, 241, 219, 187),
                        ),
                      ]);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
    );
  }
}
