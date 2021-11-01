import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeTabsItem extends StatelessWidget {
  final String? title;
  final bool? isActive;
  final Function()? onTap;

  HomeTabsItem({this.title, this.isActive, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(right: 8),
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isActive!
                ? Color.fromRGBO(69, 165, 36, 1)
                : Get.isDarkMode
                    ? Color.fromRGBO(26, 34, 44, 1)
                    : Color.fromRGBO(233, 233, 230, 1),
            borderRadius: BorderRadius.circular(40)),
        child: Text(
          "$title",
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              letterSpacing: -0.5,
              color: isActive!
                  ? Colors.white
                  : Get.isDarkMode
                      ? Colors.white
                      : Color.fromRGBO(0, 0, 0, 1)),
        ),
      ),
      onTap: onTap,
    );
  }
}
