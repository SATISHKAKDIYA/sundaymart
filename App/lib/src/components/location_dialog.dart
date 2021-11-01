import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/text_input.dart';

class LocationDialog extends StatelessWidget {
  final Function(String)? onChangeTitle;
  final Function()? onSave;

  LocationDialog({this.onChangeTitle, this.onSave});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Get.isDarkMode ? Color.fromRGBO(37, 48, 63, 1) : Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              child: Icon(
                const IconData(0xeb99, fontFamily: 'MIcon'),
                color: Get.isDarkMode ? Colors.white : Colors.black,
                size: 24,
              ),
            ),
          ),
          TextInput(
              title: "Location title".tr,
              type: TextInputType.text,
              onChange: onChangeTitle,
              isFull: true,
              placeholder: "Enter location title".tr),
          SizedBox(
            height: 20,
          ),
          TextButton(
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(0))),
            child: Container(
              width: 1.sw - 30,
              height: 60,
              alignment: Alignment.center,
              child: Text(
                "Save location".tr,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Color.fromRGBO(255, 255, 255, 1)),
              ),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(69, 165, 36, 1),
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {
              onSave!();
            },
          )
        ],
      ),
    );
  }
}
