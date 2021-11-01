import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderHistoryDialogDateItem extends StatelessWidget {
  final String? title;
  final String? date;

  const OrderHistoryDialogDateItem({this.date, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "$title",
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              letterSpacing: -0.4,
              color: Get.isDarkMode
                  ? Color.fromRGBO(130, 139, 150, 1)
                  : Color.fromRGBO(130, 130, 130, 1)),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          "$date",
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              letterSpacing: -0.4,
              color: Color.fromRGBO(255, 255, 255, 1)),
        ),
      ],
    );
  }
}
