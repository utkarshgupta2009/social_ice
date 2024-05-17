import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/profile_screen/user_profile_controller.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/widgets/chat_widgets/ChatListCard.dart';

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
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseServices.firestore
              .collection("users")
              .doc(FirebaseServices.auth.currentUser?.uid)
              .collection("chats")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No chats done by user"));
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  String chatWith = snapshot.data!.docs[index]["chatWith"];
                  return FutureBuilder<UserModel>(
                    future: FirebaseServices().getUserDetails(chatWith),
                    builder: (context, futureSnapshot) {
                      if (futureSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (futureSnapshot.hasError) {
                        return Text('Error: ${futureSnapshot.error}');
                      } else if (futureSnapshot.hasData) {
                        UserModel userData = futureSnapshot.data!;
                        return ChatListCard(
                          user: userData,
                          chatId: snapshot.data!.docs[index].id,
                        );
                      } else {
                        return const Center(
                            child: Text('Something went wrong'));
                      }
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ));
  }
}
