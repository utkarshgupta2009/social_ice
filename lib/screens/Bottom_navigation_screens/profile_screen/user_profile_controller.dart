import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:social_ice/models/user_model.dart';
import 'package:social_ice/services/firebase_services.dart';

class userProfileController extends GetxController {
  static userProfileController get instance => Get.find();
  RxString profileImagePath = ''.obs;
  Future<UserModel> getCurrentUserData() {
    final uid = FirebaseServices.auth.currentUser!.uid;
    return FirebaseServices().getUserDetails(uid);
  }
}
