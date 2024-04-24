import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/profile_screen/profile_screen_ui.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/profile_screen/user_profile_controller.dart';
import 'package:social_ice/services/firebase_services.dart';

class ProfileScreenBuilder extends StatefulWidget {
  const ProfileScreenBuilder({super.key});

  @override
  State<ProfileScreenBuilder> createState() => _ProfileScreenBuilderState();
}

class _ProfileScreenBuilderState extends State<ProfileScreenBuilder> {
  final profilecontroller = Get.put(userProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: FirebaseServices.firestore.collection("users").doc(FirebaseServices.auth.currentUser?.uid as String).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  
                  return ProfileScreen(snapshot: snapshot.data);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text("something went wrong"),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
