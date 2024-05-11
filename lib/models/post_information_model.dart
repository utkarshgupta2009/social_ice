import 'package:cloud_firestore/cloud_firestore.dart';

enum MediaType { image, video }

class PostModel {
  String? userId;
  String? username;
  String? userProfileImageUrl;
  String? postId;
  String? mediaUrl;
  int? totalLikes;
  int? totalComments;
  String? caption;
  String? publishesDateTime;
  MediaType? mediaType; // New field to indicate the type of media

  PostModel({
    this.userId,
    this.username,
    this.userProfileImageUrl,
    this.postId,
    this.mediaUrl,
    this.totalLikes,
    this.totalComments,
    this.caption,
    this.publishesDateTime,
    this.mediaType, // New field
  });

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "username": username,
        "userProfileImageUrl": userProfileImageUrl,
        "postId": postId,
        "mediaUrl": mediaUrl,
        "totalLikes": totalLikes,
        "totalComments": totalComments,
        "caption": caption,
        "publishesDateTime": publishesDateTime,
        "mediaType": mediaType?.toString().split('.').last, // Convert enum to string
      };

  static PostModel fromDocumentSnapshot(DocumentSnapshot snapshot) {
    var docSnapshot = snapshot.data() as Map<String, dynamic>;

    return PostModel(
      userId: docSnapshot["userId"],
      username: docSnapshot["username"],
      userProfileImageUrl: docSnapshot["userProfileImageUrl"],
      postId: docSnapshot["postId"],
      mediaUrl: docSnapshot["mediaUrl"],
      totalLikes: docSnapshot["totalLikes"],
      totalComments: docSnapshot["totalComments"],
      caption: docSnapshot["caption"],
      publishesDateTime: docSnapshot["publishesDateTime"],
      mediaType: docSnapshot["mediaType"] == "image"
          ? MediaType.image
          : docSnapshot["mediaType"] == "video"
              ? MediaType.video
              : null,
    );
  }
}
