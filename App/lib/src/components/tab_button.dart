import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TabButton extends StatelessWidget {
  final bool? isActive;
  final String? title;
  final IconData? icon;
  final bool? isSecond;

  TabButton({this.isActive, this.title, this.icon, this.isSecond = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.33.sw,
      height: 40,
      alignment: isSecond! ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 0.28.sw,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isActive!
                ? Color.fromRGBO(69, 165, 36, 1)
                : Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              this.icon,
              size: 22.sp,
              color: isActive!
                  ? Color.fromRGBO(255, 255, 255, 1)
                  : Get.isDarkMode
                      ? Color.fromRGBO(130, 139, 150, 1)
                      : Color.fromRGBO(136, 136, 126, 1),
            ),
            Text(
              title!,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  letterSpacing: -0.5,
                  color: isActive!
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Get.isDarkMode
                          ? Color.fromRGBO(130, 139, 150, 1)
                          : Color.fromRGBO(136, 136, 126, 1)),
            )
          ],
        ),
      ),
    );
  }
}
