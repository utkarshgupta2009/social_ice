import 'package:get/get.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadReelController extends GetxController {
 
   getVideoThumbnail(String videopath) async {
    final  videoThumbnail = await VideoThumbnail.thumbnailFile(video: videopath);
    print(videoThumbnail.toString());

    return videoThumbnail.toString();
  }
}
