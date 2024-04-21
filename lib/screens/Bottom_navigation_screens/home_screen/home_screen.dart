import 'package:flutter/material.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/home_screen/feed_page.dart';
import 'package:social_ice/screens/Bottom_navigation_screens/home_screen/message_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          title: const Text(
            "SOCIALice",
            style: TextStyle(
                color: Color(0xffFF8911), fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (_currentPage == 0) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
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
        body: PageView(
          controller: _pageController,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: const [FeedPage(), MessageScreen()],
        ),
      ),
    );
  }
}
