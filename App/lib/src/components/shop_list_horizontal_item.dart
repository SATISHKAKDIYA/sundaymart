import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';

class ShopListHorizontalItem extends StatelessWidget {
  final String? name;
  final String? backImageUrl;
  final String? description;
  final String? openHour;
  final String? closeHour;

  ShopListHorizontalItem(
      {this.name,
      this.backImageUrl,
      this.description,
      this.openHour,
      this.closeHour});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 255,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          color: Get.isDarkMode
              ? Color.fromRGBO(26, 34, 44, 1)
              : Color.fromRGBO(251, 251, 248, 1),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: <Widget>[
          Container(
            height: 211,
            width: 170,
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Color.fromRGBO(37, 48, 63, 1)
                    : Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 0,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(23, 27, 32, 0.13)
                          : Color.fromRGBO(169, 169, 150, 0.13))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: Image(
                      width: 170,
                      height: 118,
                      fit: BoxFit.cover,
                      image: NetworkImage("$GLOBAL_IMAGE_URL$backImageUrl")),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  height: 93,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$name",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          letterSpacing: -0.4,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                      Text(
                        "$description",
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            letterSpacing: -0.4,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(130, 139, 150, 1)
                                : Color.fromRGBO(136, 136, 126, 1)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.center,
            height: 44,
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    const IconData(0xf20e, fontFamily: 'MIcon'),
                    size: 18.sp,
                    color: Color.fromRGBO(255, 161, 0, 1),
                  ),
                  margin: EdgeInsets.only(right: 5),
                ),
                Text(
                  "$openHour — $closeHour",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                    letterSpacing: -0.4,
                    color: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
