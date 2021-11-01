import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileTextField extends StatelessWidget {
  final String? text;
  final String? value;
  final Widget? widget;
  final bool isObscureText;
  final bool enabled;
  final Function(String)? onChange;
  final TextInputType? type;

  ProfileTextField(
      {this.text,
      this.value,
      this.widget,
      this.isObscureText = false,
      this.enabled = true,
      this.type = TextInputType.text,
      this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            TextField(
              obscureText: isObscureText,
              enabled: enabled,
              onChanged: onChange,
              keyboardType: type,
              controller: TextEditingController(text: value)
                ..selection = TextSelection.fromPosition(
                    TextPosition(offset: value!.length)),
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  height: 1.4,
                  letterSpacing: -0.4,
                  color: Get.isDarkMode
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(0, 0, 0, 1)),
              decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1))),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1))),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1))),
                  labelText: text,
                  labelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      letterSpacing: -0.4,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(130, 139, 150, 1)
                          : Color.fromRGBO(0, 0, 0, 0.3))),
            ),
            if (widget != null) widget!
          ],
        ));
  }
}
