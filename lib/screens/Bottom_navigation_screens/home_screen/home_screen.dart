import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:social_ice/screens/auth_screens/login/login_screen.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/widgets/my_text_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              FirebaseServices.auth.signOut();
              Get.snackbar("Logged Out", "Logged out successfully");
              Get.offAll(const LoginScreen());
            },
            child: const Text("Log Out"),
          ),
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: Padding(
              padding: EdgeInsets.all(Get.height * 0.008),
              child: IconButton(
                onPressed: () {},
                icon: Image.asset('assets/images/sideDrawer.png'),
              ),
            ),
            title: const Text(
              "Buy with reels",
              style: TextStyle(color: Color.fromARGB(255, 241, 219, 187)),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings, color: Color(0xffFF8911)))
            ],
          ),
          body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: Get.width * 0.95,
                    child: MyTextField(
                        controller: searchController,
                        hintText: "search",
                        obscureText: false,
                        prefixIcon: Icon(
                          Icons.search,
                          size: Get.height * 0.035,
                        )),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
