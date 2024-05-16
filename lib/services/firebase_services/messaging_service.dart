import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/chat_model.dart';
import 'package:social_ice/services/firebase_services.dart';

class MessagingServices {
  static var auth = FirebaseAuth.instance;
  static var storage = FirebaseStorage.instance;
  static var firestore = FirebaseFirestore.instance;

  void sendMessage(String chatId, ChatMessage message, String messageId) async {
    try {
      await FirebaseServices.firestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .doc(messageId)
          .set(message.toJson());
    } catch (exp) {
      Get.snackbar("Error", exp.toString());
    }
  }
}
