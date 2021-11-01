import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LostConnection extends StatelessWidget {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Image(
              image: AssetImage("lib/assets/images/dark_mode/empty.png"),
              width: 1.sw,
              height: 0.7.sw,
              fit: BoxFit.fitWidth,
            ),
            Text(
              "Internet connection is not available.".tr,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  letterSpacing: -0.4,
                  color: Color.fromRGBO(0, 0, 0, 1)),
            )
          ],
        ),
      ),
    );
  }
}
