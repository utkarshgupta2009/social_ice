import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_ice/screens/upload_reel/upload_reel_screen.dart';

class UploadMediaController extends GetxController {
 

  var selectedImagePath = ''.obs;
  RxBool signupButtonTapped = false.obs;
  var selectedVideoPath = ''.obs;

  void getImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
    } else {
      Get.snackbar("Error", "No image selected");
    }
  }

  void getVideo(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickVideo(source: imageSource);
    if (pickedFile != null) {
      selectedVideoPath.value = pickedFile.path;
      Get.to(const UploadReelScreen());
    } else {
      Get.snackbar("Error", "No Video selected");
    }
  }
}
