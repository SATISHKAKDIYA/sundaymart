import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/extended_sign_button.dart';
import 'package:githubit/src/components/password_input.dart';
import 'package:githubit/src/components/sign_button.dart';
import 'package:githubit/src/components/text_input.dart';
import 'package:githubit/src/controllers/sign_up_controller.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final SignUpController controller = Get.put(SignUpController());

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
                width: 1.sw,
                height: 22,
                margin: EdgeInsets.only(top: 0.075.sh, right: 16, left: 30),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
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
                    InkWell(
                      onTap: () {
                        Get.toNamed("/signin");
                      },
                      child: Text(
                        "Sign In".tr,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp,
                            letterSpacing: -1,
                            color: Color.fromRGBO(69, 165, 36, 1)),
                      ),
                    ),
                  ],
                )),
            Positioned(
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
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Sign Up".tr,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 35.sp,
                                letterSpacing: -2,
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(0, 0, 0, 1)),
                          ),
                          margin: EdgeInsets.only(bottom: 0.023.sh),
                        ),
                        TextInput(
                          title: "Name".tr,
                          placeholder: "Joe",
                          defaultValue: controller.name.value,
                          onChange: controller.onChangeName,
                        ),
                        Divider(
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1),
                          height: 1,
                        ),
                        TextInput(
                          title: "Surname".tr,
                          placeholder: "Antonio",
                          defaultValue: controller.surname.value,
                          onChange: controller.onChangeSurname,
                        ),
                        Divider(
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1),
                          height: 1,
                        ),
                        TextInput(
                            title: "Phone number".tr,
                            defaultValue: controller.phone.value,
                            type: TextInputType.number,
                            onChange: controller.onChangePhone,
                            placeholder: "+998 90 900 00 00"),
                        Divider(
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1),
                          height: 1,
                        ),
                        PasswordInput(
                          title: "Password".tr,
                          onChange: controller.onChangePassword,
                        ),
                        Divider(
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1),
                          height: 1,
                        ),
                        PasswordInput(
                          title: "Password".tr,
                          onChange: controller.onChangePasswordConfirm,
                        ),
                        SizedBox(
                          height: 0.045.sh,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SignButton(
                              title: "Sign Up".tr,
                              loading: controller.loading.value,
                              onClick: controller.signUpWithPhone,
                            ),
                            ExtendedSignButton(
                              title: "Sign Up with".tr,
                              loading: controller.loadingSocial.value,
                              onSignInWithGoogle: (id, name, email, photoUrl) {
                                controller.signUpWithSocial(
                                    id, name, email, photoUrl);
                              },
                              onSignInWithFacebook:
                                  (id, name, email, photoUrl) {
                                controller.signUpWithSocial(
                                    id, name, email, photoUrl);
                              },
                            )
                          ],
                        )
                      ],
                    );
                  })),
            )
          ]),
        ),
      ),
    );
  }
}
