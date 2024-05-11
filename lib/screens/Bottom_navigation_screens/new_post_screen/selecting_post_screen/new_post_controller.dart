import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class NewPostController extends GetxController {
  RxString selectedPostPath = ''.obs;
  RxString mediumType = ''.obs;
  RxString mediumId = ''.obs;
}
