import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageGet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw - 30,
      margin: EdgeInsets.only(bottom: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            margin: EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                color: Color.fromRGBO(233, 233, 230, 1)),
            child: Text(
              "Ok I am wating for you",
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                  letterSpacing: -0.5,
                  color: Color.fromRGBO(0, 0, 0, 1)),
            ),
          ),
          Text(
            "06:30 AM",
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                height: 1.2,
                letterSpacing: -0.5,
                color: Color.fromRGBO(136, 136, 126, 1)),
          ),
        ],
      ),
    );
  }
}
