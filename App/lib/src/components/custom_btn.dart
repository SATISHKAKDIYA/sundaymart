import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final double? width;
  final double? height;
  final Color? backColor;
  final Function()? onPress;

  CustomButton(
      {this.title, this.height, this.width, this.backColor, this.onPress});

  @override
  Widget build(BuildContext build) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
      child: TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(0)),
            backgroundColor: MaterialStateProperty.all<Color>(this.backColor!),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ))),
        onPressed: onPress,
        child: Text(
          title!,
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Color.fromRGBO(255, 255, 255, 1)),
        ),
      ),
    );
  }
}
