import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/profile_screen/user_profile_controller.dart';
import 'package:social_ice/widgets/ChatListCard.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final profilecontroller = Get.put(userProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Messages",
            style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
          ),
      ),
        body: FutureBuilder(
            future: profilecontroller.getCurrentUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;
                  return ListView.builder(
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return ChatListCard(user: userData);
                      });
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
