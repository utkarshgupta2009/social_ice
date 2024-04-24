import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/screens/splashScreen/splash_screen_controller.dart';


class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final controller = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: Image.asset(
        'assets/logos/official_logo.png',),
    );
  }
}
