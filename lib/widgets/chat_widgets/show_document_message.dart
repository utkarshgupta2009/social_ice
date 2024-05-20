import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_ice/models/chat_model.dart';
import 'package:social_ice/services/firebase_services.dart';

class ShowDocumentMessage extends StatefulWidget {
  final ChatMessage chatMessage;

  const ShowDocumentMessage({Key? key, required this.chatMessage})
      : super(key: key);

  @override
  State<ShowDocumentMessage> createState() => _ShowDocumentMessageState();
}

class _ShowDocumentMessageState extends State<ShowDocumentMessage> {
  bool _isLoading = false;
  double _progress = 0;
  String _filePath = '';

  Future<void> _downloadFile(String url, String fileName) async {
    setState(() {
      _isLoading = true;
      _progress = 0;
    });

    try {
      // Get the application documents directory
      Directory appDocDir = await getApplicationCacheDirectory();
      String savePath = '${appDocDir.path}/$fileName';

      // Download the file
      Dio dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total;
            });
          }
        },
      );

      setState(() {
        _filePath = savePath;
      });

      // Handle file opening here
      OpenFilex.open(_filePath);
    } catch (e) {
      print("Error downloading file: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection:
          widget.chatMessage.senderId == FirebaseServices.auth.currentUser?.uid
              ? TextDirection.rtl
              : TextDirection.ltr,
      children: [
        Padding(
          padding: EdgeInsets.all(
            Get.height * 0.01,
          ),
          child: Container(
            width: Get.width * 0.7,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color.fromARGB(255, 226, 221, 221),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        await _downloadFile(widget.chatMessage.content,
                            widget.chatMessage.filename);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.chatMessage.filename,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(value: _progress),
                    ),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () async {
                      await _downloadFile(widget.chatMessage.content,
                          widget.chatMessage.filename);
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
