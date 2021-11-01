import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/controllers/sign_up_controller.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhonePage extends GetView<SignUpController> {
  final TextEditingController textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      body: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          height: 1.sh,
          child: Stack(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 0.05.sh),
              child: Image(
                image: AssetImage(Get.isDarkMode
                    ? "lib/assets/images/dark_mode/image9.png"
                    : "lib/assets/images/light_mode/image9.png"),
                height: 0.52.sh,
                width: 1.sw,
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
              width: 1.sw,
              height: 22,
              margin: EdgeInsets.only(top: 0.075.sh, right: 16, left: 30),
              alignment: Alignment.centerLeft,
              child: Text(
                "$APP_NAME",
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                    letterSpacing: -1,
                    color: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1)),
              ),
            ),
            Obx(() => Positioned(
                  bottom: 0,
                  child: Container(
                    width: 1.sw,
                    padding: EdgeInsets.only(
                        top: 0.022.sh,
                        left: 0.0725.sw,
                        right: 0.0725.sw,
                        bottom: 0.08.sh),
                    decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Color.fromRGBO(37, 48, 63, 1)
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Verify phone".tr,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 35.sp,
                                letterSpacing: -2,
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(0, 0, 0, 1)),
                          ),
                          margin: EdgeInsets.only(bottom: 0.016.sh),
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                                text: TextSpan(
                                    text: "Code is sent to ".tr,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                        color: Get.isDarkMode
                                            ? Color.fromRGBO(255, 255, 255, 1)
                                            : Color.fromRGBO(0, 0, 0, 1)),
                                    children: <TextSpan>[
                                  TextSpan(
                                      text: controller.phone.value,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp,
                                          color: Get.isDarkMode
                                              ? Color.fromRGBO(255, 255, 255, 1)
                                              : Color.fromRGBO(0, 0, 0, 1)))
                                ]))),
                        Container(
                          margin: EdgeInsets.only(top: 0.032.sh),
                          child: Form(
                            key: formKey,
                            child: Padding(
                                padding: EdgeInsets.symmetric(),
                                child: PinCodeTextField(
                                  appContext: context,
                                  pastedTextStyle: TextStyle(
                                    color: Color.fromRGBO(235, 237, 242, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[0-9]+')),
                                  ],
                                  length: 6,
                                  obscureText: false,
                                  obscuringCharacter: '*',
                                  animationType: AnimationType.fade,
                                  hintCharacter: "0",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25.sp,
                                      color: Get.isDarkMode
                                          ? Color.fromRGBO(130, 139, 150, 0.26)
                                          : Color.fromRGBO(
                                              136, 136, 126, 0.26)),
                                  pinTheme: PinTheme(
                                    borderWidth: 1,
                                    shape: PinCodeFieldShape.underline,
                                    fieldHeight: 0.10.sw,
                                    fieldWidth: 0.10.sw,
                                    activeColor: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    selectedColor: Get.isDarkMode
                                        ? Color.fromRGBO(37, 48, 63, 1)
                                        : Colors.white,
                                    activeFillColor: Get.isDarkMode
                                        ? Color.fromRGBO(37, 48, 63, 1)
                                        : Colors.white,
                                    inactiveColor:
                                        Color.fromRGBO(224, 224, 221, 1),
                                    selectedFillColor: Get.isDarkMode
                                        ? Color.fromRGBO(37, 48, 63, 1)
                                        : Colors.white,
                                    inactiveFillColor: Get.isDarkMode
                                        ? Color.fromRGBO(37, 48, 63, 1)
                                        : Colors.white,
                                  ),
                                  cursorColor: Get.isDarkMode
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1),
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  textStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 25.sp,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  backgroundColor: Get.isDarkMode
                                      ? Color.fromRGBO(37, 48, 63, 1)
                                      : Colors.white,
                                  enableActiveFill: true,
                                  errorAnimationController:
                                      controller.errorController,
                                  controller: textEditingController,
                                  keyboardType: TextInputType.number,
                                  onCompleted: (v) {},
                                  onChanged: (value) {
                                    controller.onChangeSmsCode(value);
                                  },
                                  beforeTextPaste: (text) {
                                    return true;
                                  },
                                )),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 0.03.sh),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Didn’t recieve code?".tr,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    letterSpacing: -0.5,
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1)),
                              ),
                              Text(
                                " ${"Request again".tr}",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    letterSpacing: -0.5,
                                    color: Color.fromRGBO(69, 165, 36, 1)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            width: 0.845.sw,
                            height: 56,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: Color.fromRGBO(69, 165, 36, 1)),
                            margin: EdgeInsets.only(top: 0.05.sh),
                            alignment: Alignment.center,
                            child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                      EdgeInsetsGeometry>(EdgeInsets.all(0))),
                              onPressed: () =>
                                  controller.confirmSignUpWithPhone(),
                              child: Text(
                                "Verify and Create account".tr,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.sp,
                                    color: Color.fromRGBO(255, 255, 255, 1)),
                              ),
                            )),
                      ],
                    ),
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}
