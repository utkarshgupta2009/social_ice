import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/user_model.dart';


class ChatListCard extends StatefulWidget {
  final UserModel user;

  const ChatListCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatListCard> createState() => _ChatListCardState();
}

class _ChatListCardState extends State<ChatListCard> {
  @override
  Widget build(BuildContext contex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          margin: const EdgeInsets.only(bottom: 7, top: 7, left: 4, right: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 3,
          child: InkWell(
              onTap: () {},
              child:  ListTile(
                title: Text(widget.user.name.toString(),
                      style:  TextStyle(
                        fontSize: Get.height*0.02
                      ),),
                subtitle: Text(
                  widget.user.username.toString(),
                  maxLines: 2,
                ),
                leading:  CircleAvatar(
                  backgroundImage: NetworkImage(widget.user.profilePicUrl.toString()),
                ),
                trailing:  Column(
                  children: [
                    const Text(
                      "20:09",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CircleAvatar(
                      backgroundColor: Colors.redAccent,
                      radius: Get.width*0.025,
                      child:  Text("1",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Get.width*0.025
                      ),),
                                        ),
                    )
                  ],
                ),
              ))),
    );
    

  }
}
