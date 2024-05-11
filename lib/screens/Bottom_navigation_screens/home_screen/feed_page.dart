import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:social_ice/models/post_information_model.dart';
import 'package:social_ice/screens/bottom_navigation_screens/home_screen/home_screen_controller.dart';
import 'package:social_ice/screens/auth_screens/login/login_screen.dart';
import 'package:social_ice/services/firebase_services.dart';
import 'package:social_ice/widgets/my_text_field.dart';
import 'package:social_ice/widgets/post_widget.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late ScrollController scrollController;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  final controller = Get.put(HomeScreenController());

  Future<dynamic> _refreshFuture =
      FirebaseServices.firestore.collection("posts").get();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _refreshFuture = fetchData(); // Initial data fetch
  }

  Future<dynamic> fetchData() async {
    return await FirebaseServices.firestore.collection("posts").get();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _refreshFuture = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          title: SizedBox(
            width: Get.width * 0.5,
            child: const Stack(
              children: [
                Positioned(
                  child: Text(
                    "SOCIALice",
                    style: TextStyle(
                        color: Color.fromARGB(255, 65, 63, 63),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Positioned(
                  left: 3,
                  child: Text(
                    "SOCIALice",
                    style: TextStyle(
                        color: Color(0xffFF8911), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (controller.currentPage == 0) {
                    controller.pageController.value.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                icon: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset('assets/images/chat.png'),
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseServices.auth.signOut();
            Get.snackbar("Logged Out", "Logged out successfully");
            Get.offAll(const LoginScreen());
          },
          child: const Text("Log Out"),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.03,
                    right: Get.width * 0.03,
                    bottom: Get.width * 0.03),
                child: MyTextField(
                    controller: searchController,
                    hintText: "search",
                    obscureText: false,
                    prefixIcon: Icon(
                      Icons.search,
                      size: Get.height * 0.035,
                    )),
              ),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: _refresh,
                child: FutureBuilder(
                    future: _refreshFuture,
                    builder: (context, snapshot) {
                      return ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            PostModel postData = PostModel.fromDocumentSnapshot(
                                snapshot.data!.docs[index]);
                            return PostWidget(post: postData);
                          });
                    }),
              ))
            ],
          ),
        ));
  }
}
