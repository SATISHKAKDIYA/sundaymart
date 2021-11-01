import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomCheckbox extends StatelessWidget {
  final bool? isChecked;

  CustomCheckbox({this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        isChecked!
            ? const IconData(0xeb80, fontFamily: 'MIcon')
            : const IconData(0xeb7d, fontFamily: 'MIcon'),
        size: 24.sp,
        color: isChecked!
            ? Color.fromRGBO(69, 165, 36, 1)
            : Get.isDarkMode
                ? Color.fromRGBO(255, 255, 255, 1)
                : Color.fromRGBO(0, 0, 0, 1),
      ),
    );
  }
}
