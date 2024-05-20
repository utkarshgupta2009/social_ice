import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/chat_model.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/utils/cachedImage.dart';

import 'package:social_ice/utils/video_player_widget.dart';

class ShowMediaMessage extends StatefulWidget {
  final ChatMessage chatMessage;

  const ShowMediaMessage({super.key, required this.chatMessage});

  @override
  State<ShowMediaMessage> createState() => _ShowMediaMessageState();
}

class _ShowMediaMessageState extends State<ShowMediaMessage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.chatMessage.senderId == FirebaseServices.auth.currentUser?.uid? TextDirection.rtl:TextDirection.ltr,
      children: [
        Padding(
          padding: EdgeInsets.all(
             Get.height * 0.01,
          ),
          child: Container(
            width: Get.width*0.7,
            //padding: EdgeInsets.all(Get.height * 0.018),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color.fromARGB(255, 226, 221, 221)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: Get.height * 0.4,
                width: Get.width*0.7,
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: widget.chatMessage.fileType == Filetype.image
                    ? CachedImage(widget.chatMessage.content)
                    : CustomVideoPlayer(
                        videoUrl: widget.chatMessage.content.toString()),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
