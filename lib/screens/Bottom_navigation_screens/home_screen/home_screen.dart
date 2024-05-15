import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/screens/bottom_navigation_screens/home_screen/feed_page/feed_page.dart';
import 'package:social_ice/screens/bottom_navigation_screens/home_screen/home_screen_controller.dart';
import 'package:social_ice/screens/bottom_navigation_screens/home_screen/message_screen/message_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(() => PageView(
          controller: controller.pageController.value,
          onPageChanged: (int page) {
            setState(() {
              controller.currentPage = page;
            });
          },
          children: const [FeedPage(), MessageScreen()],
        ),)
      ),
    );
  }
}
