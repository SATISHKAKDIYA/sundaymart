import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckoutDot extends StatelessWidget {
  final bool isFilled;
  final bool isLast;
  final bool isSettings;

  CheckoutDot(
      {this.isFilled = false, this.isLast = false, this.isSettings = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.04.sw,
      height: 6,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: isSettings && isFilled
              ? Get.isDarkMode
                  ? Color.fromRGBO(37, 48, 63, 1)
                  : Color.fromRGBO(255, 255, 255, 1)
              : isSettings
                  ? Color.fromRGBO(243, 213, 107, 1)
                  : isLast
                      ? Color.fromRGBO(50, 125, 24, 1)
                      : isFilled
                          ? Color.fromRGBO(255, 184, 0, 1)
                          : Get.isDarkMode
                              ? Color.fromRGBO(130, 139, 150, 1)
                              : Color.fromRGBO(225, 225, 215, 1)),
    );
  }
}
