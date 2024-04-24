import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppButton extends StatelessWidget {
  final dynamic onPressed;
  final String buttonLabel;
  Color? color;
  Color? textColor;
  AppButton(
      {super.key,
      required this.onPressed,
      required this.buttonLabel,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.height * 0.02),
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: color ?? Colors.black,
        child: Text(
          buttonLabel,
          style:  TextStyle(
              color: textColor ?? Color.fromARGB(255, 255, 215, 175),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
