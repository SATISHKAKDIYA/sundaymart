import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderHistoryDialogStep extends StatelessWidget {
  final IconData? icon;
  final bool? status;
  final bool? passed;

  OrderHistoryDialogStep({this.icon, this.status, this.passed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      margin: EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: status!
              ? Color.fromRGBO(255, 184, 0, 1)
              : passed!
                  ? Color.fromRGBO(69, 165, 36, 1)
                  : Color.fromRGBO(220, 220, 213, 1),
          borderRadius: BorderRadius.circular(18)),
      child: Icon(
        icon,
        color: passed! || status!
            ? Get.isDarkMode
                ? Color.fromRGBO(0, 0, 0, 1)
                : Color.fromRGBO(255, 255, 255, 1)
            : Get.isDarkMode
                ? Color.fromRGBO(130, 139, 150, 1)
                : Color.fromRGBO(136, 136, 126, 1),
        size: 20.sp,
      ),
    );
  }
}
