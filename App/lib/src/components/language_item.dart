import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/custom_checkbox.dart';

class LanguageItem extends StatelessWidget {
  final bool? isChecked;
  final String? text;
  final String? imageUrl;
  final Function()? onPress;

  LanguageItem({this.isChecked, this.text, this.imageUrl, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.all(0))),
          onPressed: () => onPress!(),
          child: Container(
            width: 1.sw - 30,
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Get.isDarkMode
                          ? Color.fromRGBO(23, 27, 32, 0.13)
                          : Color.fromRGBO(169, 169, 150, 0.13),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 0)
                ],
                color: Get.isDarkMode
                    ? Color.fromRGBO(37, 48, 63, 1)
                    : Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                CustomCheckbox(
                  isChecked: isChecked,
                ),
                Container(
                  height: 15,
                  width: 20,
                  margin: EdgeInsets.only(left: 20, right: 8),
                  child: CachedNetworkImage(
                    width: 20,
                    height: 15,
                    fit: BoxFit.cover,
                    imageUrl: "$GLOBAL_IMAGE_URL$imageUrl",
                    placeholder: (context, url) => Container(
                      width: 20,
                      height: 15,
                      alignment: Alignment.center,
                      child: Icon(
                        const IconData(0xee4b, fontFamily: 'MIcon'),
                        color: Color.fromRGBO(233, 233, 230, 1),
                        size: 20.sp,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Text(
                  "$text",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    letterSpacing: -0.5,
                    color: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
