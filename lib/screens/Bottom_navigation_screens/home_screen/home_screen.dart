import 'package:flutter/material.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/home_screen/feed_page.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/home_screen/message_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        children: const [FeedPage(), MessageScreen()],
      ),
    );
  }
}
