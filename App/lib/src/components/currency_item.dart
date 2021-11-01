import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:githubit/src/components/custom_checkbox.dart';

class CurrencyItem extends StatelessWidget {
  final bool? isChecked;
  final String? text;
  final Function()? onPress;

  CurrencyItem({this.isChecked, this.text, this.onPress});

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
            decoration: BoxDecoration(boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromRGBO(169, 169, 150, 0.13),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  spreadRadius: 0)
            ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                CustomCheckbox(
                  isChecked: isChecked,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "$text",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      letterSpacing: -0.5,
                      color: Color.fromRGBO(0, 0, 0, 1)),
                ),
              ],
            ),
          )),
    );
  }
}
