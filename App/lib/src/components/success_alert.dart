import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SuccessAlert extends StatelessWidget {
  final String? message;
  final Function()? onClose;

  SuccessAlert({this.message, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 1.sw - 30,
      margin: EdgeInsets.only(left: 15, bottom: 0.08.sh, right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(69, 165, 36, 1),
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 25,
                spreadRadius: 0,
                color: Color.fromRGBO(55, 147, 23, 0.28))
          ]),
      child: Row(
        children: <Widget>[
          Container(
            width: 0.18.sw,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            )),
            child: Icon(
              const IconData(0xeb79, fontFamily: 'MIcon'),
              size: 28.sp,
              color: Colors.white,
            ),
          ),
          Container(
            width: 0.64.sw - 30,
            height: 80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Success".tr,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      letterSpacing: -1,
                      height: 1.2,
                      color: Color.fromRGBO(255, 255, 255, 1)),
                ),
                Text(
                  "$message",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      letterSpacing: -0.4,
                      height: 1.2,
                      color: Color.fromRGBO(255, 255, 255, 1)),
                )
              ],
            ),
          ),
          Container(
            width: 0.18.sw,
            height: 80,
            alignment: Alignment.center,
            child: TextButton(
                onPressed: onClose,
                child: Text(
                  "Close".tr,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      letterSpacing: -0.4,
                      color: Color.fromRGBO(255, 255, 255, 0.5)),
                )),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: Color.fromRGBO(59, 154, 27, 1)),
          )
        ],
      ),
    );
  }
}
