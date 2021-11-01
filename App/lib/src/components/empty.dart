import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Empty extends StatelessWidget {
  final String? message;

  Empty({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sw,
      width: 1.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Image(
            image: Get.isDarkMode
                ? AssetImage("lib/assets/images/dark_mode/empty.png")
                : AssetImage("lib/assets/images/light_mode/empty.png"),
            width: 1.sw,
            height: 0.7.sw,
            fit: BoxFit.fitWidth,
          ),
          Text(
            "$message",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              letterSpacing: -0.4,
              color: Get.isDarkMode
                  ? Color.fromRGBO(255, 255, 255, 1)
                  : Color.fromRGBO(0, 0, 0, 1),
            ),
          )
        ],
      ),
    );
  }
}
