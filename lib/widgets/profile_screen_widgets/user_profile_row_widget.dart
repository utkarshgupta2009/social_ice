import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class UserProfileRowWidget extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  const UserProfileRowWidget(
      {super.key, required this.titleText, required this.subtitleText, });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          titleText,
          style: TextStyle(
              color: Color.fromARGB(255, 240, 237, 234),
              fontSize: Get.height * 0.023,
              fontWeight: FontWeight.bold),
        ),
        Text(
          subtitleText,
          style: TextStyle(
              color: Color.fromARGB(255, 194, 192, 190),
              fontSize: Get.height * 0.015),
        ),
      ],
    );
  }
}
