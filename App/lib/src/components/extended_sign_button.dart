import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/auth/facebook.dart';
import 'package:githubit/src/components/auth/google.dart';

class ExtendedSignButton extends StatelessWidget {
  final String? title;
  final Function(String, String, String, String)? onSignInWithGoogle;
  final Function(String, String, String, String)? onSignInWithFacebook;
  final Function(String, String, String, String)? onSignInWithApple;
  final bool? isIos;
  final bool? loading;

  ExtendedSignButton(
      {this.title,
      this.onSignInWithGoogle,
      this.onSignInWithFacebook,
      this.onSignInWithApple,
      this.isIos = false,
      this.loading = false});

  @override
  Widget build(BuildContext build) {
    return Container(
      height: 56,
      width: 0.45.sw,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Get.isDarkMode
                ? Color.fromRGBO(19, 20, 21, 1)
                : Color.fromRGBO(243, 243, 240, 1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.0),
            ))),
        onPressed: () {},
        child: !loading!
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Text(
                      title!,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          letterSpacing: -0.4,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(130, 139, 150, 1)
                              : Color.fromRGBO(136, 136, 126, 1)),
                    ),
                  ),
                  Google(
                    onSubmit: onSignInWithGoogle,
                  ),
                  Facebook(
                    onSubmit: onSignInWithFacebook,
                  )
                ],
              )
            : SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(69, 165, 36, 1),
                ),
              ),
      ),
    );
  }
}
