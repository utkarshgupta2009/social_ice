import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/chat_model.dart';

class MessagingServices {
  static var auth = FirebaseAuth.instance;
  static var storage = FirebaseStorage.instance;
  static var firestore = FirebaseFirestore.instance;

  void sendMessage(String chatId, ChatMessage message, String messageId,
      String timestamp, String chattingWithId) async {
    try {
      await firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .set(message.toJson());

      await firestore
          .collection("chats")
          .doc(chatId)
          .set({"timestamp": timestamp});

      await firestore
          .collection("users")
          .doc(auth.currentUser?.uid)
          .collection("chats")
          .doc(chatId)
          .update({"timestamp": timestamp});

      await firestore
          .collection("users")
          .doc(chattingWithId)
          .collection("chats")
          .doc(chatId)
          .update({"timestamp": timestamp});
    } catch (exp) {
      Get.snackbar("Error", exp.toString());
    }
  }

  void saveChatIdtoFirestore(
      String currentUserId, String chattingWithUserId, String chatId) async {
    try {
      String timestamp = Timestamp.now().toString();
      await firestore
          .collection("users")
          .doc(currentUserId)
          .collection("chats")
          .doc(chatId)
          .set({"chatWith": chattingWithUserId, "timestamp": timestamp});

      await firestore
          .collection("users")
          .doc(chattingWithUserId)
          .collection("chats")
          .doc(chatId)
          .set({"chatWith": currentUserId, "timestamp": timestamp});
    } catch (exp) {}
  }

  void sendMediaMessage(
      File mediaFile,
      String chatId,
      String messageId,
      String timestamp,
      String chattingWithUserId,
      Filetype fileType,
      String filename) async {
    try {
      String mediaUrl =
          await uploadMediaMessagetoStorage(mediaFile, chatId, messageId,filename);

      ChatMessage chatMessage = ChatMessage(
          messageId: messageId,
          senderId: auth.currentUser?.uid as String,
          content: mediaUrl,
          fileType: fileType,
          timestamp: timestamp,
          filename: filename);

      sendMessage(
          chatId, chatMessage, messageId, timestamp, chattingWithUserId);
    } catch (exp) {}
  }

  Future<String> uploadMediaMessagetoStorage(
      File mediaFile, String chatId, String messageId, String filename) async {
        
    Reference reference =
        storage.ref().child("message file").child(chatId).child(messageId+filename);

    UploadTask uploadTask = reference.putFile(mediaFile);

    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
