import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CommentBottomSheet extends StatefulWidget {
  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.7, // Adjust this value as per your requirement
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To ensure the Column takes up the minimum required space
          children: [
            
            Flexible(
              flex: 8,
              child: ListView.builder(
                shrinkWrap: true, // To prevent ListView from expanding beyond its content
                itemCount: 10, // Replace with your actual comment list length
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://via.placeholder.com/50'), // Replace with actual profile picture
                    ),
                    title: Text('Comment $index'),
                    subtitle: Text('User $index'),
                  );
                },
              ),
            ),

            Flexible(
              flex: 2,
              child: 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add a comment...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),)
          ],
        ),
      ),
    );
  }
}