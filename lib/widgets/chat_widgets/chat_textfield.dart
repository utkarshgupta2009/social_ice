import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_ice/models/chat_model.dart';
import 'package:social_ice/services/firebase_services/messaging_service.dart';

// ignore: must_be_immutable
class ChatTextfield extends StatefulWidget {
  TextEditingController? controller;
  String? hintText;
  String chatId;
  String chattingWithId;

  ChatTextfield(
      {required this.controller,
      this.hintText,
      required this.chatId,
      required this.chattingWithId,
      super.key});

  @override
  State<ChatTextfield> createState() => ChatTextfieldState();
}

class ChatTextfieldState extends State<ChatTextfield> {
  final double _maxHeight = 200.0; // Maximum height for the text field
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _maxHeight,
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.elliptical(50, 50)),
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextField(
                        controller: widget.controller,
                        minLines: 1,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: widget.hintText,
                          border: InputBorder.none,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      final file = result!.files.first;
                      final fileName = file.name;
                      Filetype fileType;

                      switch (file.extension!.toLowerCase()) {
  case "pdf":
  case "docx":
  case "pptx":
  case "xlsx":
  case "doc":
  case "ppt":
    fileType = Filetype.document;
    break;

  case "jpg":
  case "jpeg":
  case "png":
  case "gif":
  case "bmp":
    fileType = Filetype.image;
    break;

  case "mp4":
  case "mkv":
  case "mov":
  case "avi":
  case "wmv":
    fileType = Filetype.video;
    break;

  default:
    fileType = Filetype.text;
    break;
}


                      final String timestamp = DateTime.now().toString();
                      final String messageId = ((MessagingServices
                              .auth.currentUser?.uid as String) +
                          Timestamp.now().millisecondsSinceEpoch.toString());
                      MessagingServices().sendMediaMessage(
                          File(file.path!),
                          widget.chatId,
                          messageId,
                          timestamp,
                          widget.chattingWithId,
                          fileType,fileName);
                    },
                    icon: const Icon(Icons.attach_file),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
