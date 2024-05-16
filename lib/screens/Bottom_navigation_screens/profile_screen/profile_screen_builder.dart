import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/profile_screen/profile_screen_ui.dart';
import 'package:social_ice/screens/bottom_navigation_screens/profile_screen/user_profile_controller.dart';
import 'package:social_ice/services/firebase_services.dart';

class ProfileScreenBuilder extends StatefulWidget {
  final String uid;
  const ProfileScreenBuilder({super.key, required this.uid});

  @override
  State<ProfileScreenBuilder> createState() => _ProfileScreenBuilderState();
}

class _ProfileScreenBuilderState extends State<ProfileScreenBuilder> {
  final profilecontroller = Get.put(userProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<UserModel>(
      future: FirebaseServices().getUserDetails(widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is still resolving
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // If there's an error in fetching the data
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.hasData) {
          // If the data is successfully fetched
          return ProfileScreen(userData: snapshot.data!);
        } else {
          // If none of the above states match (should be ConnectionState.done)
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}
