import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_ice/models/chat_model.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/services/firebase_services.dart';

class ChattingScreen extends StatefulWidget {
  final UserModel chattingWith;
  final String chatId;
  const ChattingScreen(
      {super.key, required this.chatId, required this.chattingWith});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
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
      body: StreamBuilder(
          stream: FirebaseServices.firestore
              .collection("chats")
              .doc(widget.chatId)
              .collection("messages")
              .snapshots(),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Text(snapshot.data!.docs[index]["content"]);
                });
          }),
      floatingActionButton: ElevatedButton(
          onPressed: () async {
            ChatMessage chatObject = ChatMessage(
                messageId: ((FirebaseServices.auth.currentUser?.uid as String) +
                    Timestamp.now().millisecondsSinceEpoch.toString()),
                senderId: FirebaseServices.auth.currentUser?.uid as String,
                content: "Hi bro",
                timestamp: DateTime.now());
            await FirebaseServices.firestore
                .collection("chats")
                .doc(widget.chatId)
                .collection("messages")
                .doc(((FirebaseServices.auth.currentUser?.uid as String) +
                    Timestamp.now().millisecondsSinceEpoch.toString()))
                .set(chatObject.toJson());
          },
          child: Text("send message")),
    );
  }
}
