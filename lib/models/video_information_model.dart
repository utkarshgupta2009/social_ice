import 'package:cloud_firestore/cloud_firestore.dart';

class VideoInformationModel {
  String? userId;
  String? username;
  String? userProfileImageUrl;
  String? videoId;
  String? videoUrl;
  String? thumbnailUrl;
  int? totalLikes;
  int? totalComments;
  String? caption;
  String? publishesDateTime;

  VideoInformationModel({
    this.userId,
    this.username,
    this.userProfileImageUrl,
    this.videoId,
    this.videoUrl,
    this.thumbnailUrl,
    this.totalLikes,
    this.totalComments,
    this.caption,
    this.publishesDateTime,
  });

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "username": username,
        "userProfileImageUrl": userProfileImageUrl,
        "videoId": videoId,
        "videoUrl": videoUrl,
        "thumbnailUrl": thumbnailUrl,
        "totalLikes": totalLikes,
        "totalComments": totalComments,
        "caption": caption,
        "publishesDateTime": publishesDateTime
      };

  static VideoInformationModel fromDocumentSnapshot(DocumentSnapshot snapshot) {
    var docSnapshot = snapshot.data() as Map<String, dynamic>;

    return VideoInformationModel(
        userId: docSnapshot["userId"],
        username: docSnapshot["username"],
        userProfileImageUrl: docSnapshot["userProfileImageUrl"],
        videoId: docSnapshot["videoId"],
        videoUrl: docSnapshot["videoUrl"],
        thumbnailUrl: docSnapshot["thumbnailUrl"],
        totalLikes: docSnapshot["totalLikes"],
        totalComments: docSnapshot["totalComments"],
        caption: docSnapshot["caption"],
        publishesDateTime: docSnapshot["publishesDateTime"]);
  }
}
