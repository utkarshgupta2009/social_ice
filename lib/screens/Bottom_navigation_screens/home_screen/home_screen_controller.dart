import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  Rx<PageController> pageController = PageController().obs;
  int currentPage = 0;

  @override
  void onInit() {
    super.onInit();
    pageController.value = PageController(initialPage: currentPage);
  }
}
