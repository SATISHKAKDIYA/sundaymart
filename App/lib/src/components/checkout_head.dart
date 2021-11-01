import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckoutHead extends StatelessWidget {
  final String? text;

  CheckoutHead({this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$text",
      style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          letterSpacing: -0.4,
          color: Get.isDarkMode
              ? Color.fromRGBO(130, 139, 150, 1)
              : Color.fromRGBO(136, 136, 126, 1)),
    );
  }
}
