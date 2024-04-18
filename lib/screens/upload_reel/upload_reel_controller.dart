import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadReelController extends GetxController {
  /*late Rx<File?> _pickedImage;
  File? get profileImage => _pickedImage.value;

  @override
  void onInit() {
    _pickedImage.value=null;
    super.onInit();
  }

  void chooseImageFromGallery() async {
    final imagePicked =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imagePicked != null) {
      Get.snackbar("Profile photo", "Successfully selected profile image",
          snackPosition: SnackPosition.BOTTOM);
    }

    _pickedImage = Rx<File?>(File(imagePicked!.path));
  }

  void captureImageFromCamera() async {
    final imagePicked =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (imagePicked != null) {
      Get.snackbar("Profile photo", "Successfully selected profile image");
    }

    _pickedImage = Rx<File?>(File(imagePicked!.path));
  }*/

  /*compressVideoFile(String videoPath) async {
    final compressedVideoFile = await VideoCompress.compressVideo(videoPath,
        quality: VideoQuality.Res1280x720Quality);
    return compressedVideoFile!.file;
  }*/

   getVideoThumbnail(String videopath) async {
    final  videoThumbnail = await VideoThumbnail.thumbnailFile(video: videopath);
    print(videoThumbnail.toString());

    return videoThumbnail.toString();
  }
}
