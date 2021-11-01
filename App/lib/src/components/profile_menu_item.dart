import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileMenuItem extends StatelessWidget {
  final String? title;
  final Function()? onClick;
  final bool? noUnderline;
  final IconData? icon;
  final Widget? rightWidget;

  ProfileMenuItem(
      {this.onClick,
      this.title,
      this.icon,
      this.noUnderline = false,
      this.rightWidget});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(0))),
        onPressed: onClick,
        child: Container(
            margin: EdgeInsets.only(left: 25, right: 23),
            decoration: BoxDecoration(
                border: !noUnderline!
                    ? Border(
                        bottom: BorderSide(
                            width: 1,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(130, 139, 150, 0.15)
                                : Color.fromRGBO(136, 136, 126, 0.15)))
                    : null),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 20,
                      height: 70,
                      margin: EdgeInsets.only(right: 15),
                      child: Icon(
                        icon,
                        size: 24.sp,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                    Text(
                      title!,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        letterSpacing: -0.4,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(0, 0, 0, 1),
                      ),
                    )
                  ],
                ),
                if (rightWidget != null) rightWidget!
              ],
            )));
  }
}
