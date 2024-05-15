import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/profile_screen/user_profile_controller.dart';
import 'package:social_ice/services/firebase_services.dart';
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
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
        ),
        body: StreamBuilder(
            stream: FirebaseServices.firestore
                .collection("users")
                .doc(FirebaseServices.auth.currentUser?.uid)
                .collection("chats")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No chats done by user"));
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      String chatWith = snapshot.data!.docs[index]["chatWith"];
                      return FutureBuilder(
                          future: FirebaseServices().getUserDetails(chatWith),
                          builder: ((context, futureSnapshot) {
                            UserModel userData =
                                futureSnapshot.data as UserModel;
                            return ChatListCard(user: userData,chatId: snapshot.data!.docs[index].id,);
                          }));
                    }));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
