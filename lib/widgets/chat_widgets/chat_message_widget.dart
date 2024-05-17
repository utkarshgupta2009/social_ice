import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/chat_model.dart';
import 'package:social_ice/services/firebase_services.dart';

class ChatMessageWidget extends StatefulWidget {
  final ChatMessage message;
  const ChatMessageWidget({super.key, required this.message});

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  String currentUserId = FirebaseServices.auth.currentUser?.uid as String;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        textDirection: widget.message.senderId == currentUserId
            ? TextDirection.rtl
            : TextDirection.ltr,
        children: [
          Column(
            children: [
              Container(
                  constraints: BoxConstraints(maxHeight: Get.height * 0.5,
                  maxWidth: Get.width*0.8),
                  decoration: BoxDecoration(
                      borderRadius: widget.message.senderId == currentUserId
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))
                          : const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                      color: widget.message.senderId != currentUserId
                          ? const Color.fromARGB(154, 255, 156, 56)
                          : const Color.fromARGB(221, 255, 202, 149)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(
                      widget.message.content,
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
