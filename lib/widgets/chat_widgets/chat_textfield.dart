import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatTextfield extends StatefulWidget {
  TextEditingController? controller;
  String? hintText;

  ChatTextfield({required this.controller, this.hintText, super.key});

  @override
  State<ChatTextfield> createState() => ChatTextfieldState();
}

class ChatTextfieldState extends State<ChatTextfield> {
  final double _maxHeight = 200.0; // Maximum height for the text field
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: _maxHeight,
              ),
              child: TextField(
                controller: widget.controller,
                minLines: 1,
                maxLines: null, // Allow unlimited lines
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  suffix: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.attach_file)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                  ),
                  hintText: widget.hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
