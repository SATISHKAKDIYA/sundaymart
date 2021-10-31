import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutBottomButton extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  final Color? backgroundColor;
  final bool? isActive;

  CheckoutBottomButton(
      {this.title, this.onTap, this.backgroundColor, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, 1),
                  color: Color.fromRGBO(169, 169, 150, 0.13),
                  blurRadius: 2,
                  spreadRadius: 0)
            ],
            borderRadius: BorderRadius.circular(30),
            color:
                isActive! ? backgroundColor : Color.fromRGBO(136, 136, 126, 1)),
        alignment: Alignment.center,
        child: Text(
          "$title",
          style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 18.sp,
              color: Color.fromRGBO(255, 255, 255, 1)),
        ),
      ),
    );
  }
}
