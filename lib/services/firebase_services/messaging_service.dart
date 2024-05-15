import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessagingServices {
  static var auth = FirebaseAuth.instance;
  static var storage = FirebaseStorage.instance;
  static var firestore = FirebaseFirestore.instance;

  
}
