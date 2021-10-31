import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckoutButton extends StatelessWidget {
  final bool? isActive;
  final String? title;
  final IconData? icon;

  CheckoutButton({this.isActive, this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.44.sw,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              width: 1.5,
              color: isActive!
                  ? Color.fromRGBO(69, 165, 36, 1)
                  : Get.isDarkMode
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(173, 173, 149, 1)),
          color:
              isActive! ? Color.fromRGBO(69, 165, 36, 1) : Colors.transparent),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            this.icon,
            size: 22.sp,
            color: isActive!
                ? Color.fromRGBO(255, 255, 255, 1)
                : Get.isDarkMode
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(136, 136, 126, 1),
          ),
          SizedBox(
            width: 10,
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
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(136, 136, 126, 1)),
          )
        ],
      ),
    );
  }
}
