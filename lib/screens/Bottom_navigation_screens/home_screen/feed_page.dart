import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/post_information_model.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/home_screen/home_screen_controller.dart';
import 'package:social_ice/screens/auth_screens/login/login_screen.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/widgets/my_text_field.dart';
import 'package:social_ice/widgets/post_widget.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  ScrollController scrollController = ScrollController();
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  final controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          title: const Text(
            "SOCIALice",
            style: TextStyle(
                color: Color(0xffFF8911), fontWeight: FontWeight.bold),
          ),
          actions: [
             IconButton(
                onPressed: () {
                  if (controller.currentPage == 0) {
                    controller.pageController.value.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                icon: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset('assets/images/chat.png'),
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseServices.auth.signOut();
            Get.snackbar("Logged Out", "Logged out successfully");
            Get.offAll(const LoginScreen());
          },
          child: const Text("Log Out"),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.03,
                    right: Get.width * 0.03,
                    bottom: Get.width * 0.03),
                child: MyTextField(
                    controller: searchController,
                    hintText: "search",
                    obscureText: false,
                    prefixIcon: Icon(
                      Icons.search,
                      size: Get.height * 0.035,
                    )),
              ),
              Expanded(
                  child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return PostWidget(
                            post: PostModel(
                          username: "Utkarsh",
                          userProfileImageUrl:
                              "https://i0.wp.com/picjumbo.com/wp-content/uploads/camping-on-top-of-the-mountain-during-sunset-free-photo.jpg",
                          imageUrl:
                              "https://i0.wp.com/picjumbo.com/wp-content/uploads/camping-on-top-of-the-mountain-during-sunset-free-photo.jpg",
                        ));
                      }))
            ],
          ),
        ));
  }
}
