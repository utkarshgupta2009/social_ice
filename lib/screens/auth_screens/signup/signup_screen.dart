import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_ice/screens/auth_screens/login/login_screen.dart';
import 'package:social_ice/screens/auth_screens/signup/signup_controller.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/utils/uploadMedia.dart';
import 'package:social_ice/widgets/app_button.dart';
import 'package:social_ice/widgets/my_text_field.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final signupController = Get.put(SignupController());
  final uploadController = Get.put(UploadMediaController());

  final signUpEmailKey = GlobalKey<FormState>();
  final signUpPasswordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: ListView(children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.05),
                child: const Text(
                  "Sign up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
              //SizedBox(height: Get.height * 0.07),
              Obx(
                () => InkWell(
                  onTap: () {
                    Get.defaultDialog(
                        title: "Choose an option to continue",
                        titleStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        titlePadding: const EdgeInsets.all(20),
                        middleText: "Upload image from",
                        middleTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                        textCancel: "gallery",
                        textConfirm: "camera",
                        onConfirm: () {
                          uploadController.getImage(ImageSource.camera);
                          //Get.back();
                        },
                        onCancel: () {
                          uploadController.getImage(ImageSource.gallery);
                          //Get.back();
                        },
                        contentPadding: const EdgeInsets.all(20));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: Get.height * 0.03,
                        bottom: Get.height * 0.016,
                        left: Get.height * 0.07),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: Get.height * 0.08,
                          backgroundImage:
                              uploadController.selectedImagePath.value == ''
                                  ? const AssetImage(
                                      "assets/images/profile_image.png")
                                  : FileImage(File(uploadController
                                      .selectedImagePath
                                      .value)) as ImageProvider,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  title: "Choose an option to continue",
                                  titleStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  titlePadding: const EdgeInsets.all(20),
                                  middleText: "Upload image from",
                                  middleTextStyle:
                                      const TextStyle(fontWeight: FontWeight.bold),
                                  textCancel: "gallery",
                                  textConfirm: "camera",
                                  onConfirm: () {
                                    uploadController
                                        .getImage(ImageSource.camera);
                                    //Get.back();
                                  },
                                  onCancel: () {
                                    uploadController
                                        .getImage(ImageSource.gallery);
                                    //Get.back();
                                  },
                                  contentPadding: const EdgeInsets.all(20));
                            },
                            child: const Text("Choose\n profile\n image"))
                      ],
                    ),
                  ),
                ),
              ),
              Form(
                key: signUpEmailKey,
                child: MyTextField(
                  controller: emailController,
                  hintText: "email",
                  obscureText: false,
                  prefixIcon: Icon(Icons.account_circle_rounded,
                      size: Get.height * 0.028),
                  inputType: 'email',
                  onChanged: (text) {
                    if (signUpEmailKey.currentState!.validate()) {}
                  },
                ),
              ),
              SizedBox(height: Get.height * 0.025),
              MyTextField(
                controller: usernameController,
                hintText: "username",
                obscureText: false,
                prefixIcon: Icon(Icons.account_circle_rounded,
                    size: Get.height * 0.028),
              ),

              SizedBox(height: Get.height * 0.025),
              Form(
                key: signUpPasswordKey,
                child: MyTextField(
                  controller: passwordController,
                  hintText: "password",
                  obscureText: true,
                  prefixIcon: Icon(Icons.lock, size: Get.height * 0.028),
                  inputType: 'password',
                  onChanged: (text) {
                    if (signUpPasswordKey.currentState!.validate()) {}
                  },
                ),
              ),
              SizedBox(height: Get.height * 0.034),
              AppButton(
                  onPressed: () {
                    if (uploadController.selectedImagePath.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        usernameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      signupController.signupButtonTapped = true.obs;

                      Get.defaultDialog(
                          titlePadding: const EdgeInsets.all(20),
                          contentPadding: const EdgeInsets.all(20),
                          middleText: " Kindly wait",
                          title: "Creating account",
                          titleStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          actions: [
                            const CircularProgressIndicator(),
                          ]);
                      FirebaseServices().createAccountWithEmailAndPassword(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        usernameController.text.trim(),
                        File(uploadController.selectedImagePath.value),
                      );
                    } else {
                      Get.defaultDialog(
                          titlePadding: const EdgeInsets.all(20),
                          contentPadding: const EdgeInsets.all(20),
                          middleText:
                              " Kindly fill all the fields correctly and check that you have selected a profile image",
                          title: "Sign up unsuccessfull",
                          titleStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          confirm: AppButton(
                              onPressed: () {
                                Get.back();
                              },
                              buttonLabel: "try again"));
                    }
                  },
                  buttonLabel: signupController.signupButtonTapped == true.obs
                      ? "Loading"
                      : "Sign up"),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: Get.height * 0.04),
                          child: const Text(
                            "use google instead ",
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
                                    backgroundColor: const Color.fromARGB(
                                        255, 240, 237, 234),
                                    child: Image.asset(
                                        "assets/images/google_icon.png")))),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: Get.height * 0.05),
                          child: const Text(
                            "or login",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(1),
                            child: TextButton(
                              onPressed: () {
                                Get.off(() => const LoginScreen(),
                                    transition: Transition.rightToLeft);
                              },
                              child: const Text(
                                "Click here to login",
                                style: TextStyle(color: Color(0xffFF8911)),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    ));
  }
}
