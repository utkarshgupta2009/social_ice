import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? username;
  String? name;
  
  String? uid;
  String? profilePicUrl;
  String? userEmail;

  UserModel(
      {this.uid,
      this.name,
      this.username,
      this.profilePicUrl,
      
      this.userEmail});

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "username": username,
        "userEmail": userEmail,
        "image": profilePicUrl,
        
      };

  static UserModel fromSnap(DocumentSnapshot<Map<String,dynamic>> document) {
    var dataSnapshot = document.data()!;
    return UserModel(
      uid: document.id,
      name: dataSnapshot["name"],
      username: dataSnapshot["username"],
      userEmail: dataSnapshot["userEmail"],
      profilePicUrl: dataSnapshot["image"],
      
    );
  }
}
