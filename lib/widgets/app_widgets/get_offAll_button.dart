import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class GetOffAllButtonWidget extends StatelessWidget {
  final dynamic goToPage;
  final String buttonLabel;
  const GetOffAllButtonWidget({super.key, required this.goToPage, required this.buttonLabel});

 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Get.height * 0.02),
      child: SizedBox(
        height: Get.height * 0.05,
        width: Get.width * 0.5,
        child: MaterialButton(
          onPressed: () {
            Get.offAll(goToPage, transition: Transition.rightToLeft);
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.black,
          child:  Text(
            buttonLabel,
            style: const TextStyle(
                color: Color.fromARGB(255, 255, 215, 175),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
