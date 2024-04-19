import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/home_screen/home_screen.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/profile_screen/profile_screen_builder.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/profile_screen/user_profile_controller.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/reels_screen/reels_screen.dart';
import 'package:social_ice/utils/cachedImage.dart';

class BottomNavigatorScreen extends StatefulWidget {
  const BottomNavigatorScreen({super.key});

  @override
  State<BottomNavigatorScreen> createState() => _BottomNavigatorScreenState();
}

class _BottomNavigatorScreenState extends State<BottomNavigatorScreen> {
  int bottomNavigatorIndex = 0;
  final controller = Get.put(userProfileController());

  @override
  Widget build(BuildContext context) {
    List<Widget> bottom_navigation_screens_list = [
      const HomeScreen(),
      const ReelsScreen(),
      const ProfileScreenBuilder()
    ];
    return Stack(
      children: [
        IndexedStack(
          index: bottomNavigatorIndex,
          children: bottom_navigation_screens_list,
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: Get.width,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Color.fromARGB(145, 0, 0, 0),
                spreadRadius: 17,
               ),
                BoxShadow(blurRadius: 4, color: Color.fromARGB(175, 0, 0, 0),
                spreadRadius: 5,
               ),
               
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.09, vertical: Get.height * 0.007),
              child: FutureBuilder(
                  future: controller.getCurrentUserData(),
                  builder: (context, snapshot) {
                    UserModel user = snapshot.data as UserModel;
                    return GNav(
                        gap: 5,
                        padding: EdgeInsets.all(Get.height * 0.012),
                        onTabChange: (index) {
                          setState(() {
                            bottomNavigatorIndex = index;
                          });
                        },
                        selectedIndex: bottomNavigatorIndex,
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
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
