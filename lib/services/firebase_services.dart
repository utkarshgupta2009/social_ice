//import 'dart:html';
//import 'dart:io';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/models/video_information_model.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/bottom_navigation.dart';
import 'package:social_ice/screens/auth_screens/signup/signup_controller.dart';
import 'package:social_ice/screens/upload_reel/upload_reel_controller.dart';
//import 'package:social_ice/screens/upload_reel/upload_reel_controller.dart';

class FirebaseServices {
  static var auth = FirebaseAuth.instance;
  static var storage = FirebaseStorage.instance;
  static var firestore = FirebaseFirestore.instance;
  final controller = Get.put(SignupController());

  void createAccountWithEmailAndPassword(String userEmail, String userPassword,
      String userName, File profileImage) async {
    try {
      //step 1 -> adding user details in firestore authentication
      UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);

      //step 2 -> uploading profile pic to database and fetching the url of profile pic for storing in user details

      String profilePicUrl = await uploadImageToFirebaseStorage(profileImage);

      //step 3 -> add user details to firestore

      UserModel newUser = UserModel(
        uid: auth.currentUser!.uid,
        name: "johnDoe",
        username: userName,
        profilePicUrl: profilePicUrl,
        userEmail: userEmail,
      );

      await firestore
          .collection("users")
          .doc(credential.user!.uid)
          .set(newUser.toJson());

      Get.snackbar("Signed up successfully",
          "Congratulations your account has been creaated successfully");
      Get.offAll(const BottomNavigatorScreen());
    } catch (error) {
      Get.snackbar(error.toString(), "please try again");
    }
  }

  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    Reference reference = storage
        .ref()
        .child("Users Profile Images")
        .child(auth.currentUser!.uid);

    UploadTask uploadTask = reference.putFile(imageFile);

    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // ignore: non_constant_identifier_names
  void LoginUserWithEmailAndPassword(
      String userEmail, String userPassword) async {
    try {
      await auth.signInWithEmailAndPassword(
          email: userEmail, password: userPassword);

      Get.snackbar(
          "Login successfull", "Congratulations logged in successfully");
      Get.offAll(const BottomNavigatorScreen());
    } catch (error) {
      Get.snackbar("Login unsuccessfull", "please try again");
    }
  }

  Future<UserModel> getUserDetails(String uid) async {
    final snapshot =
        await firestore.collection("users").where("uid", isEqualTo: uid).get();

    final userData = snapshot.docs.map((e) => UserModel.fromSnap(e)).single;
    return userData;
  }

  Future<VideoInformationModel> getVideoDetails(
      String userId, String videoId) async {
    final snapshot = await firestore
        .collection("reels")
        .where("videoId", isEqualTo: videoId)
        .get();

    final VideoInformationModel videoData = snapshot.docs
        .map((e) => VideoInformationModel.fromDocumentSnapshot(e))
        .single;

    return videoData;
  }

  uploadVideoToFirestoreDatabase(String videoId, String videoPath) async {
    UploadTask videoUploadTask = FirebaseServices.storage
        .ref()
        .child("All video files")
        .child(videoId)
        .putFile(File(videoPath));

    TaskSnapshot snapshot = await videoUploadTask;

    String downloadUrl = await snapshot.ref.getDownloadURL();

    // Get.snackbar("video uploaded to database", "");

    return downloadUrl;
  }

  uploadVideoThumbnailToFirestoreDatabase(
      String videoId, String videoPath) async {
    try {
      UploadTask ThumbnailUploadTask = FirebaseServices.storage
          .ref()
          .child("All thumbnail files")
          .child(videoId)
          .putFile(
              File(await UploadReelController().getVideoThumbnail(videoPath)));

      TaskSnapshot snapshot = await ThumbnailUploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      print(error);
      Get.snackbar("unsuccessfull", error.toString());
    }
  }

  saveVideoInformationToFireStoreDatabase(
      videoPath, String videoCaption) async {
    try {
      Get.back();
      Get.back();
      Get.snackbar("Video upload in progress",
          "you will get a confirmation when video is uploaded");

      UserModel userData =
          await getUserDetails(FirebaseServices.auth.currentUser!.uid);
      String? videoId = auth.currentUser!.uid +
          DateTime.now().millisecondsSinceEpoch.toString();
      //upload video to storage
      String videoDownloadUrl =
          await uploadVideoToFirestoreDatabase(videoId, videoPath);
      //upload thumbnail to storage
      String thumbnailDownloadUrl =
          await uploadVideoThumbnailToFirestoreDatabase(videoId, videoPath);

      VideoInformationModel videoObject = VideoInformationModel(
        userId: userData.uid,
        username: userData.username,
        userProfileImageUrl: userData.profilePicUrl,
        videoId: videoId,
        videoUrl: videoDownloadUrl,
        thumbnailUrl: thumbnailDownloadUrl,
        totalLikes: 0,
        totalComments: 0,
        caption: videoCaption,
        publishesDateTime: DateTime.now().millisecondsSinceEpoch.toString(),
      );

      await firestore
          .collection("users")
          .doc(userData.uid)
          .collection("videos")
          .doc(videoId)
          .set(videoObject.toJson());

      await firestore
          .collection("reels")
          .doc(videoId)
          .set(videoObject.toJson());

      Get.snackbar("Video uploaded", "you have successfully shared your video");
    } catch (error) {
      Get.snackbar("Video upload unsuccessfull", error.toString());
      //Get.off(UserProfileScreen());
    }
  }

  Future<int> getVideoCount(String? userid) async {
    final CollectionReference<Map<String, dynamic>> videoList =
        firestore.collection("users").doc(userid).collection("videos");

    AggregateQuerySnapshot query = await videoList.count().get();
    print("no of videos, ${query.count}");

    return query.count!.toInt();
  }

  Future<void> updateBuyerRecord(UserModel userData) async {
    try {
      await firestore
          .collection("users")
          .doc(userData.uid)
          .update(userData.toJson());
      Get.snackbar("Success", "Profile updated successfully!!");
    } catch (error) {
      Get.snackbar("Error", "Please try again");
    }
  }

  void followUser(UserModel followUserData) async {
    try {
      UserModel currentUserData =
          await getUserDetails(auth.currentUser?.uid as String);

      await firestore
          .collection("users")
          .doc(auth.currentUser?.uid)
          .collection("following")
          .doc(followUserData.uid)
          .set(followUserData.toJson());

      await firestore
          .collection('users')
          .doc(followUserData.uid)
          .collection('followers')
          .doc(currentUserData.uid)
          .set(currentUserData.toJson());
      Get.snackbar("Followed", followUserData.username.toString());
    } catch (expection) {
      Get.snackbar("Error", expection.toString());
    }
  }

  Future<void> unfollowUser(UserModel targetUserData) async {
    try {
      // Remove the target user from the current user's following sub-collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser?.uid)
          .collection('following')
          .doc(targetUserData.uid)
          .delete();

      // Remove the current user from the target user's followers sub-collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserData.uid)
          .collection('followers')
          .doc(auth.currentUser?.uid)
          .delete();

      Get.snackbar("Unfollowed", targetUserData.username.toString());
    } catch (expection) {
      Get.snackbar("Error", expection.toString());
    }
  }

  Future<bool> checkIfFollowing(String targetUserId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser?.uid)
        .collection('following')
        .doc(targetUserId)
        .get();

    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }
}
