import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:social_ice/screens/auth_screens/login/login_screen.dart';
import 'package:social_ice/screens/auth_screens/signup/signup_screen.dart';
import 'package:social_ice/widgets/get_to_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
              child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: Get.height * 0.1, bottom: Get.height * 0.01),
            child: Text("Buy With Reels",
                style: TextStyle(
                    fontSize: Get.height * 0.05, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: Get.height * 0.1,
                bottom: Get.height * 0.01,
                left: Get.height * 0.1,
                right: Get.height * 0.1),
            child: Lottie.asset("assets/lottie/welcome_screen_cart.json"),
          ),
          SizedBox(
            height: Get.height*0.04,
          ),
          const GetToButtonWidget(buttonLabel: "Login", goToPage: LoginScreen()),
          const GetToButtonWidget(goToPage: SignUpScreen(), buttonLabel: "Sign up")
        ],
      ))),
    );
  }
}
