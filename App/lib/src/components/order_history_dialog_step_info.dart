import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderHistoryDialogStepInfo extends StatelessWidget {
  final bool? status;
  final bool? passed;
  final String? title;
  final String? time;

  OrderHistoryDialogStepInfo({this.status, this.passed, this.time, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.8.sw,
      height: 52,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: status!
            ? Color.fromRGBO(255, 184, 0, 1)
            : passed!
                ? Color.fromRGBO(69, 165, 36, 1)
                : Color.fromRGBO(220, 220, 213, 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "$title",
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              letterSpacing: -0.4,
              color: passed! || status!
                  ? Get.isDarkMode
                      ? Color.fromRGBO(0, 0, 0, 1)
                      : Color.fromRGBO(255, 255, 255, 1)
                  : Get.isDarkMode
                      ? Color.fromRGBO(130, 139, 150, 1)
                      : Color.fromRGBO(136, 136, 126, 1),
            ),
          ),
          if (time!.length > 0)
            Container(
              decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                width: 1,
                color: passed! || status!
                    ? Get.isDarkMode
                        ? Color.fromRGBO(0, 0, 0, 1)
                        : Color.fromRGBO(255, 255, 255, 0.18)
                    : Get.isDarkMode
                        ? Color.fromRGBO(130, 139, 150, 0.18)
                        : Color.fromRGBO(136, 136, 126, 0.18),
              ))),
              padding: EdgeInsets.only(left: 10),
              child: Text("$time",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    letterSpacing: -0.4,
                    color: passed! || status!
                        ? Get.isDarkMode
                            ? Color.fromRGBO(0, 0, 0, 1)
                            : Color.fromRGBO(255, 255, 255, 1)
                        : Get.isDarkMode
                            ? Color.fromRGBO(130, 139, 150, 1)
                            : Color.fromRGBO(136, 136, 126, 1),
                  )),
            )
        ],
      ),
    );
  }
}
