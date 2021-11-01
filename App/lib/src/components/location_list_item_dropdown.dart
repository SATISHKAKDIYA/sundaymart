import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LocationListItemDropDown extends StatelessWidget {
  final Function()? onEdit;
  final Function()? onDelete;

  LocationListItemDropDown({this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      height: 100,
      margin: EdgeInsets.only(top: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Get.isDarkMode ? Color.fromRGBO(37, 48, 63, 1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Get.isDarkMode
                    ? Color.fromRGBO(0, 0, 0, 0.33)
                    : Color.fromRGBO(169, 169, 150, 0.33),
                offset: Offset(0, 21),
                blurRadius: 44,
                spreadRadius: 0)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            child: Row(
              children: <Widget>[
                Icon(
                  const IconData(0xec86, fontFamily: 'MIcon'),
                  color: Get.isDarkMode
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(0, 0, 0, 1),
                  size: 20.sp,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Edit".tr,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      letterSpacing: -0.4,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1)),
                ),
              ],
            ),
            onTap: onEdit,
          ),
          InkWell(
            child: Row(
              children: <Widget>[
                Icon(
                  const IconData(0xec2a, fontFamily: 'MIcon'),
                  color: Get.isDarkMode
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(0, 0, 0, 1),
                  size: 20.sp,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Delete".tr,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      letterSpacing: -0.4,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1)),
                ),
              ],
            ),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}
