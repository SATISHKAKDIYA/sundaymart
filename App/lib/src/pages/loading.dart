import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/controllers/auth_controller.dart';

class Loading extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      body: Container(
          width: 1.sw,
          height: 1.sh,
          alignment: Alignment.center,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(
                0.5.sw,
              ),
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Color.fromRGBO(69, 165, 36, 1),
                ),
              ))),
    );
  }
}
