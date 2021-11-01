import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarCustom extends StatelessWidget {
  final String? title;
  final bool? hasBack;
  final Function()? onBack;
  final Widget? actions;
  AppBarCustom({this.title, this.actions, this.hasBack = true, this.onBack});

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = AppBar().preferredSize.height;

    return Container(
      width: 1.sw,
      height: statusBarHeight + appBarHeight,
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 2,
                spreadRadius: 0,
                color: Get.isDarkMode
                    ? Color.fromRGBO(23, 27, 32, 0.13)
                    : Color.fromRGBO(169, 169, 150, 0.13))
          ],
          color: Get.isDarkMode
              ? Color.fromRGBO(37, 48, 63, 1)
              : Color.fromRGBO(255, 255, 255, 1)),
      padding: EdgeInsets.only(left: 15, right: 15, top: statusBarHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (hasBack!)
                InkWell(
                  child: Container(
                    width: 34,
                    height: 34,
                    child: Icon(
                      const IconData(0xea64, fontFamily: 'MIcon'),
                      size: 24.sp,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                  onTap: () {
                    if (onBack != null) onBack!();
                    Get.back();
                  },
                ),
              Container(
                height: 34,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 8),
                child: Text(
                  "$title",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      letterSpacing: -0.4,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1)),
                ),
              ),
            ],
          ),
          if (actions != null) actions!
        ],
      ),
    );
  }
}
