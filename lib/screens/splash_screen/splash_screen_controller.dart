import 'package:get/get.dart';
import 'package:social_ice/screens/bottom_navigation_screens/bottom_navigation.dart';
import 'package:social_ice/screens/welcome_screen/welcome_screen.dart';
import 'package:social_ice/services/firebase_services.dart';


class SplashScreenController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(
         const Duration(seconds: 3),
        () => FirebaseServices.auth.currentUser!=null? Get.offAll(
              () => const BottomNavigatorScreen(),
            ):Get.offAll(
              () => const WelcomeScreen(),
            ));
  }
}
