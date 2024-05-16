import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/chat_model.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/services/firebase_services/messaging_service.dart';
import 'package:social_ice/widgets/app_button.dart';
import 'package:social_ice/widgets/chat_message.dart';
import 'package:social_ice/widgets/expandable_textfield.dart';

class ChattingScreen extends StatefulWidget {
  final UserModel chattingWith;
  final String chatId;
  const ChattingScreen(
      {super.key, required this.chatId, required this.chattingWith});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(widget.chattingWith.profilePicUrl.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.chattingWith.name.toString(),
                    textScaler: const TextScaler.linear(0.9),
                  ),
                  Text("@${widget.chattingWith.username}",
                      textScaler: const TextScaler.linear(0.7))
                ],
              ),
            )
          ],
        ),
        forceMaterialTransparency: true,
      ),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseServices.firestore
                  .collection("chats")
                  .doc(widget.chatId)
                  .collection("messages")
                  .orderBy("timestamp")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // If the future is still waiting for data, display a loading indicator
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there is an error while fetching data, display the error message
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  // If the future has completed with data
                  return Flexible(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          ChatMessage chatData = ChatMessage.fromSnapshot(
                              snapshot.data!.docs[index]);
                          return ChatMessageWidget(message: chatData);
                        }),
                  );
                } else {
                  // If the connection state is not covered by any of the above cases
                  return const Text('Something went wrong');
                }
              }),
          SizedBox(
            width: Get.width,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                    child: ExpandableTextField(controller: messageController)),
                AppButton(
                    onPressed: () {
                      String messageId = ((FirebaseServices
                              .auth.currentUser?.uid as String) +
                          Timestamp.now().millisecondsSinceEpoch.toString());
                      MessagingServices().sendMessage(
                          widget.chatId,
                          ChatMessage(
                              messageId: messageId,
                              senderId: FirebaseServices.auth.currentUser?.uid
                                  as String,
                              content: messageController.text,
                              timestamp: Timestamp.now().toString()),
                          messageId);

                      messageController.clear();
                    },
                    buttonLabel: "send"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
