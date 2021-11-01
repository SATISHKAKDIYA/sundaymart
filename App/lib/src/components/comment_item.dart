import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommentItem extends StatelessWidget {
  final bool? isLast;
  final String? author;
  final String? date;
  final double? rating;
  final String? comment;

  const CommentItem(
      {this.isLast = false, this.author, this.date, this.comment, this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          border: Border(
              bottom: isLast!
                  ? BorderSide(color: Colors.transparent)
                  : BorderSide(
                      width: 1,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(255, 255, 255, 0.04)
                          : Color.fromRGBO(0, 0, 0, 0.04)))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$author",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        height: 1.2,
                        letterSpacing: -0.3,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(0, 0, 0, 1)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "$date",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        height: 1.2,
                        letterSpacing: -0.3,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(0, 0, 0, 1)),
                  ),
                ],
              ),
              Container(
                width: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(
                      const IconData(0xf18e, fontFamily: 'MIcon'),
                      size: 20.sp,
                      color: Color.fromRGBO(255, 161, 0, 1),
                    ),
                    Text(
                      "$rating",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          letterSpacing: -0.35,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "$comment",
            softWrap: true,
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                height: 1.8,
                letterSpacing: -0.5,
                color: Get.isDarkMode
                    ? Color.fromRGBO(130, 139, 150, 1)
                    : Color.fromRGBO(136, 136, 126, 1)),
          ),
        ],
      ),
    );
  }
}
