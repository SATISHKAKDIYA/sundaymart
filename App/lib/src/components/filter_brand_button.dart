import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FilterBrandButton extends StatelessWidget {
  final String? name;
  final int? id;
  final bool? isActive;
  final Function()? onTap;

  FilterBrandButton({this.id, this.name, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: IntrinsicWidth(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromRGBO(69, 165, 36, 0.13),
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                  blurRadius: 2)
            ],
            borderRadius: BorderRadius.circular(10),
            color: isActive!
                ? Color.fromRGBO(69, 165, 36, 1)
                : Get.isDarkMode
                    ? Color.fromRGBO(19, 20, 21, 1)
                    : Color.fromRGBO(233, 233, 230, 1)),
        child: Text(
          "$name",
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              letterSpacing: -0.4,
              color: isActive!
                  ? Color.fromRGBO(255, 255, 255, 1)
                  : Get.isDarkMode
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(0, 0, 0, 1)),
        ),
      )),
      onTap: onTap,
    );
  }
}
