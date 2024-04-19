import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? userId;
  String? username;
  String? userProfileImageUrl;
  String? postId;
  String? imageUrl;
  int? totalLikes;
  int? totalComments;
  String? caption;
  String? publishesDateTime;

  PostModel({
    this.userId,
    this.username,
    this.userProfileImageUrl,
    this.postId,
    this.imageUrl,
    this.totalLikes,
    this.totalComments,
    this.caption,
    this.publishesDateTime,
  });

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "username": username,
        "userProfileImageUrl": userProfileImageUrl,
        "postId": postId,
        "imageUrl": imageUrl,
        "totalLikes": totalLikes,
        "totalComments": totalComments,
        "caption": caption,
        "publishesDateTime": publishesDateTime
      };

  static PostModel fromDocumentSnapshot(DocumentSnapshot snapshot) {
    var docSnapshot = snapshot.data() as Map<String, dynamic>;

    return PostModel(
        userId: docSnapshot["userId"],
        username: docSnapshot["username"],
        userProfileImageUrl: docSnapshot["userProfileImageUrl"],
        postId: docSnapshot["postId"],
        imageUrl: docSnapshot["imageUrl"],
        totalLikes: docSnapshot["totalLikes"],
        totalComments: docSnapshot["totalComments"],
        caption: docSnapshot["caption"],
        publishesDateTime: docSnapshot["publishesDateTime"]);
  }
}
