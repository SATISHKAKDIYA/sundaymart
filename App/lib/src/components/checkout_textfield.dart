import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CheckoutTextfield extends StatelessWidget {
  final String? text;
  final String? value;
  final bool? hasButton;
  final bool? enabled;
  final Function()? onTap;
  final Function(String)? onChange;

  CheckoutTextfield(
      {this.text,
      this.hasButton = false,
      this.value,
      this.onTap,
      this.onChange,
      this.enabled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Stack(alignment: Alignment.centerRight, children: <Widget>[
          TextField(
            controller: TextEditingController(text: value)
              ..selection = TextSelection.fromPosition(
                  TextPosition(offset: value!.length)),
            enabled: enabled,
            onChanged: onChange,
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 18.sp,
                height: 1.4,
                letterSpacing: -0.4,
                color: Get.isDarkMode
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(0, 0, 0, 1)),
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(130, 139, 150, 0.2)
                            : Color.fromRGBO(136, 136, 126, 0.2))),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(130, 139, 150, 0.2)
                            : Color.fromRGBO(136, 136, 126, 0.2))),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        width: 1,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(130, 139, 150, 0.2)
                            : Color.fromRGBO(136, 136, 126, 0.2))),
                labelText: text,
                labelStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    letterSpacing: -0.4,
                    color: Get.isDarkMode
                        ? Color.fromRGBO(130, 139, 150, 1)
                        : Color.fromRGBO(136, 136, 126, 1))),
          ),
          if (hasButton!)
            InkWell(
              onTap: onTap,
              child: Text(
                "Edit".tr,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    letterSpacing: -0.5,
                    color: Color.fromRGBO(53, 105, 184, 1)),
              ),
            )
        ]));
  }
}
