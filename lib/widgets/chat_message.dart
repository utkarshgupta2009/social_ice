import 'package:flutter/material.dart';
import 'package:social_ice/models/chat_model.dart';
import 'package:social_ice/services/firebase_services.dart';

class ChatMessageWidget extends StatefulWidget {
  final ChatMessage message;
  const ChatMessageWidget({super.key, required this.message});

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.yellowAccent),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: widget.message.senderId == FirebaseServices.auth.currentUser?.uid? TextDirection.rtl:TextDirection.ltr,
        children: [
          Text(widget.message.content),
        ],
      ),
    );
  }
}
