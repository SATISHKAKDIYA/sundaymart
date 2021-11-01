import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';

class ShopLocationItem extends StatelessWidget {
  final String? name;
  final String? address;
  final String? backImage;
  final String? logoImage;
  final String? rating;

  ShopLocationItem(
      {this.name, this.address, this.rating, this.backImage, this.logoImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 162,
      height: 224,
      margin: EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Get.isDarkMode
              ? Color.fromRGBO(26, 34, 44, 1)
              : Color.fromRGBO(243, 243, 243, 1)),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Image(
                width: 162,
                height: 95,
                image: NetworkImage("$GLOBAL_IMAGE_URL$backImage")),
          ),
          Positioned(
            left: 14,
            top: 76,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                    width: 38,
                    height: 38,
                    image: NetworkImage("$GLOBAL_IMAGE_URL$logoImage")),
              ),
            ),
          ),
          Positioned(
              left: 0,
              top: 95,
              child: Container(
                width: 162,
                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 25, bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Text(
                            "$name",
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                letterSpacing: -0.4,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Color.fromRGBO(0, 0, 0, 1)),
                          ),
                        ),
                        Icon(
                          const IconData(0xf18e, fontFamily: 'MIcon'),
                          size: 14.sp,
                          color: Color.fromRGBO(255, 161, 0, 1),
                        ),
                        Text(
                          "$rating",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          const IconData(0xef09, fontFamily: 'MIcon'),
                          size: 14.sp,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(130, 139, 150, 1)
                              : Color.fromRGBO(136, 136, 126, 1),
                        ),
                        Container(
                          width: 115,
                          child: Text(
                            "$address",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                                letterSpacing: -0.4,
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(130, 139, 150, 1)
                                    : Color.fromRGBO(136, 136, 126, 1)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
