import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/controllers/product_controller.dart';

class SearchInput extends GetView<ProductController> {
  final String? title;
  final bool? hasSuffix;
  final Function(String)? onChange;
  final Function()? onTap;

  SearchInput({this.title, this.hasSuffix = true, this.onChange, this.onTap});

  onChangeHandler(value) {
    const duration = Duration(milliseconds: 800);
    if (controller.searchOnStoppedTyping != null) {
      controller.searchOnStoppedTyping!.cancel();
    }
    controller.searchOnStoppedTyping =
        new Timer(duration, () => onChange!(value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: Get.isDarkMode
                ? Color.fromRGBO(26, 34, 44, 1)
                : Color.fromRGBO(249, 249, 249, 1)),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 1.sw - 100,
              child: TextField(
                onChanged: onChangeHandler,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: title!,
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        const IconData(0xf0cd, fontFamily: 'MIcon'),
                        size: 20.sp,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(130, 139, 150, 1)
                            : Color.fromRGBO(136, 136, 126, 1),
                      ),
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      letterSpacing: -0.5,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(130, 139, 150, 1)
                          : Color.fromRGBO(136, 136, 126, 1),
                    )),
              ),
            ),
            if (hasSuffix!)
              IconButton(
                onPressed: onTap,
                icon: Icon(
                  const IconData(0xf162, fontFamily: 'MIcon'),
                  size: 20.sp,
                  color: Color.fromRGBO(136, 136, 126, 1),
                ),
              )
          ],
        ));
  }
}
