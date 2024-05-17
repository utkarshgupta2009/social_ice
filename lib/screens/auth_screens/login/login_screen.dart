import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_ice/screens/auth_screens/signup/signup_screen.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/widgets/app_widgets/app_button.dart';
import 'package:social_ice/widgets/app_widgets/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _ScreenState();
}

class _ScreenState extends State<LoginScreen> {
  final emailKey = GlobalKey<FormState>();
  final passwordKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var emailErrorText = ''.obs;
  var passwordErrorText = ''.obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: ListView(children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.1),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.07),
              Padding(
                padding: EdgeInsets.all(Get.height * 0.015),
                child: Form(
                  key: emailKey,
                  child: MyTextField(
                    controller: emailController,
                    hintText: "email",
                    obscureText: false,
                    prefixIcon: Icon(Icons.account_circle_rounded,
                        size: Get.height * 0.028),
                    inputType: 'email',
                    onChanged: (text) {
                      if (emailKey.currentState!.validate()) {}
                    },
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              Padding(
                padding: EdgeInsets.all((Get.height * 0.015)),
                child: Form(
                  key: passwordKey,
                  child: MyTextField(
                    controller: passwordController,
                    hintText: "password",
                    obscureText: true,
                    prefixIcon: Icon(Icons.lock, size: Get.height * 0.028),
                    inputType: 'password',
                    onChanged: (text) {
                      if (passwordKey.currentState!.validate()) {}
                    },
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              SizedBox(
                width: Get.width * 0.5,
                child: AppButton(
                    onPressed: () {
                      FirebaseServices().LoginUserWithEmailAndPassword(
                          emailController.text.trim(), passwordController.text);
                    },
                    buttonLabel: "Login"),
              ),
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.04),
                child: const Text(
                  "or login by google",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                          backgroundColor:
                              const Color.fromARGB(255, 240, 237, 234),
                          child:
                              Image.asset("assets/images/google_icon.png")))),
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.1),
                child: const Text(
                  "or sign up",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextButton(
                    onPressed: () {
                      Get.off(() => const SignUpScreen(),
                          transition: Transition.rightToLeft);
                    },
                    child: const Text(
                      "Click here to sign up",
                      style: TextStyle(color: Color(0xffFF8911)),
                    ),
                  ))
            ],
          ),
        ]),
      ),
    ));
  }
}
