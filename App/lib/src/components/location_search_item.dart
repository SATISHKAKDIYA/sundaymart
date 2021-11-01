import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LocationSearchItem extends StatelessWidget {
  final bool? isLast;
  final String? mainText;
  final String? address;
  final String? distance;
  final Function(String)? onClickIcon;
  final Function(String)? onClickRaw;

  LocationSearchItem(
      {this.isLast = false,
      this.mainText,
      this.address,
      this.distance,
      this.onClickRaw,
      this.onClickIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 1.sw - 70,
      decoration: BoxDecoration(
          border: isLast!
              ? null
              : Border(
                  bottom: BorderSide(
                      width: 1, color: Color.fromRGBO(136, 136, 126, 0.2)))),
      child: Row(
        children: <Widget>[
          TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(0))),
              onPressed: () => onClickRaw!(mainText!),
              child: Container(
                width: 1.sw - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "$mainText",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          letterSpacing: -0.4,
                          height: 1.25,
                          color: Get.isDarkMode ? Colors.white : Colors.black),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "$address",
                            softWrap: true,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                                letterSpacing: -0.4,
                                height: 1.2,
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(130, 139, 150, 1)
                                    : Color.fromRGBO(136, 136, 126, 1)),
                          ),
                          constraints: BoxConstraints(maxWidth: 1.sw - 150),
                        ),
                        Container(
                          width: 13,
                          child: Icon(
                            const IconData(0xeb7c, fontFamily: 'MIcon'),
                            color: Get.isDarkMode
                                ? Color.fromRGBO(130, 139, 150, 1)
                                : Color.fromRGBO(136, 136, 126, 1),
                            size: 5.sp,
                          ),
                        ),
                        // Text(
                        //   "5 km",
                        //   style: TextStyle(
                        //       fontFamily: 'Inter',
                        //       fontWeight: FontWeight.w500,
                        //       fontSize: 10.sp,
                        //       letterSpacing: -0.4,
                        //       height: 1.2,
                        //       color: Get.isDarkMode
                        //           ? Color.fromRGBO(130, 139, 150, 1)
                        //           : Color.fromRGBO(136, 136, 126, 1)),
                        // )
                      ],
                    )
                  ],
                ),
              )),
          InkWell(
              onTap: () => onClickIcon!(mainText!),
              child: Icon(
                const IconData(0xea66, fontFamily: 'MIcon'),
                color: Color.fromRGBO(136, 136, 126, 1),
              ))
        ],
      ),
    );
  }
}
