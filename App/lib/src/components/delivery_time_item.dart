import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DeliveryTimeItem extends StatelessWidget {
  final String? date;
  final String? date2;
  final String? time;
  final Color? color;
  final bool? isSelected;

  DeliveryTimeItem(
      {this.date,
      this.date2 = "",
      this.time,
      this.color,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw - 30,
        height: 90,
        padding: EdgeInsets.only(left: 24),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color:
                Get.isDarkMode ? Color.fromRGBO(37, 48, 63, 1) : Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                    text: TextSpan(
                        text: date!,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            letterSpacing: -0.4,
                            color: color),
                        children: <TextSpan>[
                      TextSpan(
                        text: date2!,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            letterSpacing: -0.4,
                            color: color),
                      )
                    ])),
                Text(
                  time!,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 14.sp,
                      letterSpacing: -0.4,
                      height: 1.7,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1)),
                ),
              ],
            ),
            if (isSelected!)
              Container(
                height: 60,
                width: 4,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(69, 165, 36, 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
              ),
          ],
        ));
  }
}
