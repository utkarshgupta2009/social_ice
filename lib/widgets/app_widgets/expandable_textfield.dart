import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExpandableTextField extends StatefulWidget {
  TextEditingController? controller;
  String? hintText;

  ExpandableTextField({required this.controller, this.hintText, super.key});

  @override
  State<ExpandableTextField> createState() => ExpandableTextFieldState();
}

class ExpandableTextFieldState extends State<ExpandableTextField> {
  double textFieldHeight = 50.0;
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
                
                onChanged: (text) {
                  final textPainter = TextPainter(
                    text: TextSpan(
                      text: text,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    maxLines: null,
                    textDirection: TextDirection.ltr,
                  )..layout(maxWidth: constraints.maxWidth - 16.0);
                  setState(() {
                    textFieldHeight =
                        textPainter.size.height + 20.0; // Add some padding
                  });
                },
                minLines: 1,
                maxLines: null, // Allow unlimited lines
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
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
