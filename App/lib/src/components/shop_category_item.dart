import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ShopCategoryItem extends StatelessWidget {
  final String? title;
  final bool? isActive;
  final IconData? icon;
  final bool? isRow;
  final int? id;
  final Function()? onClick;

  ShopCategoryItem(
      {this.title,
      this.isActive = false,
      this.icon,
      this.isRow = false,
      this.id = 0,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(0))),
        onPressed: onClick,
        child: Container(
            height: 34,
            padding: EdgeInsets.symmetric(horizontal: 18),
            margin: EdgeInsets.only(right: isRow! ? 0 : 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: isActive!
                    ? Color.fromRGBO(69, 165, 36, 1)
                    : Get.isDarkMode
                        ? Color.fromRGBO(26, 34, 44, 1)
                        : Color.fromRGBO(233, 233, 230, 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (icon != null)
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    child: Icon(
                      icon,
                      size: 16.sp,
                      color: isActive!
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                Text(
                  title!,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      letterSpacing: -0.5,
                      color: isActive!
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1)),
                ),
              ],
            )));
  }
}
