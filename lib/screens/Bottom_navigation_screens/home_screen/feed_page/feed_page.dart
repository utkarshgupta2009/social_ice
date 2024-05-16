import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  Future<QuerySnapshot> _refreshFuture = FirebaseServices.firestore
      .collection("posts")
      .where("userId", isNotEqualTo: FirebaseServices.auth.currentUser?.uid)
      .get();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _refreshFuture = fetchData(); // Initial data fetch
  }

  Future<QuerySnapshot> fetchData() async {
    return await FirebaseServices.firestore
        .collection("posts")
        .where("userId", isNotEqualTo: FirebaseServices.auth.currentUser?.uid)
        .get();
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
        resizeToAvoidBottomInset: false,
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
                      child: FutureBuilder<QuerySnapshot>(
                        future: _refreshFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.none) {
                            // If the future has not been initialized yet, display a placeholder
                            return const Center(child: Text('Loading...'));
                          } else if (snapshot.hasError) {
                            // If there is an error while fetching data, display the error message
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // If the future is still waiting for data, display a loading indicator
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.connectionState ==
                                  ConnectionState.active ||
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            // If the future has completed with data or is actively receiving updates

                            if (snapshot.data!.docs.isEmpty) {
                              // If there are no posts, display a message
                              return const Center(
                                  child: Text('No posts to show'));
                            } else {
                              // If there are posts, build the ListView
                              return ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  PostModel postData =
                                      PostModel.fromDocumentSnapshot(
                                          snapshot.data!.docs[index]);
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: Get.height * 0.02),
                                    child: PostWidget(post: postData),
                                  );
                                },
                              );
                            }
                          } else {
                            // If the connection state is not covered by any of the above cases
                            return const Center(
                                child: Text('Something went wrong'));
                          }
                        },
                      )))
            ],
          ),
        ));
  }
}
