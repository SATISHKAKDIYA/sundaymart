import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeTabButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Function()? onTap;
  final bool? isActive;

  HomeTabButton({this.icon, this.onTap, this.title, this.isActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Icon(icon!,
                  color: isActive!
                      ? Color.fromRGBO(69, 165, 36, 1)
                      : Get.isDarkMode
                          ? Color.fromRGBO(130, 139, 150, 1)
                          : Color.fromRGBO(136, 136, 126, 1)),
            ),
            Text(
              "$title",
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  letterSpacing: -0.5,
                  color: isActive!
                      ? Color.fromRGBO(69, 165, 36, 1)
                      : Get.isDarkMode
                          ? Color.fromRGBO(130, 139, 150, 1)
                          : Color.fromRGBO(136, 136, 126, 1)),
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
