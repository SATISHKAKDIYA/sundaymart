import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:githubit/src/components/dot.dart';
import 'package:get/get.dart';

class Coupon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 187,
      decoration: BoxDecoration(
          color: Color.fromRGBO(222, 31, 54, 1),
          borderRadius: BorderRadius.circular(4)),
      child: Stack(
        children: <Widget>[
          Container(
              height: 30,
              margin: EdgeInsets.only(left: 10),
              child: Row(
                children: <Widget>[
                  Icon(
                    const IconData(0xefe5, fontFamily: 'MIcon'),
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RichText(
                      text: TextSpan(
                          text: "${"Get Discount".tr} ",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              letterSpacing: -0.4,
                              color: Color.fromRGBO(255, 255, 255, 1)),
                          children: <TextSpan>[
                        TextSpan(
                            text: "Coupon".tr,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp,
                                letterSpacing: -0.4,
                                color: Color.fromRGBO(255, 255, 255, 1)))
                      ]))
                ],
              )),
          Positioned(
              top: 9,
              right: -8,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(243, 243, 240, 1),
                    borderRadius: BorderRadius.circular(6)),
              )),
          Positioned(
              top: 0,
              right: 20,
              child: Container(
                height: 30,
                width: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[Dot(), Dot(), Dot(), Dot(), Dot(), Dot()],
                ),
              ))
        ],
      ),
    );
  }
}
