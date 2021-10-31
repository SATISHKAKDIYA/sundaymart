import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsItem extends StatelessWidget {
  final Widget? rightWidget;
  final IconData? icon;
  final String? text;

  SettingsItem({this.icon, this.text, this.rightWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw - 30,
      height: 60,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Get.isDarkMode
                    ? Color.fromRGBO(23, 27, 32, 0.13)
                    : Color.fromRGBO(169, 169, 150, 0.13),
                offset: Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0)
          ],
          color: Get.isDarkMode
              ? Color.fromRGBO(37, 48, 63, 1)
              : Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                icon,
                size: 24.sp,
                color: Get.isDarkMode
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(0, 0, 0, 1),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "$text",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  letterSpacing: -0.5,
                  color: Get.isDarkMode
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ],
          ),
          if (rightWidget != null) rightWidget!
        ],
      ),
    );
  }
}
