import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/error_dialog.dart';
import 'package:githubit/src/components/profile_textfield.dart';
import 'package:githubit/src/controllers/auth_controller.dart';

class PasswordChangeBottomsheet extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
        decoration: BoxDecoration(
            color: Get.isDarkMode
                ? Color.fromRGBO(37, 48, 63, 1)
                : Color.fromRGBO(255, 255, 255, 1),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(0, -8),
                  blurRadius: 70,
                  spreadRadius: 0,
                  color: Get.isDarkMode
                      ? Color.fromRGBO(0, 0, 0, 0.25)
                      : Color.fromRGBO(169, 169, 169, 0.25))
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 0.1.sw,
              height: 5,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(204, 204, 204, 1),
                  borderRadius: BorderRadius.circular(5)),
            ),
            SizedBox(
              height: 30,
            ),
            ProfileTextField(
              text: "Current password".tr,
              value: controller.currentPassword.value,
              isObscureText: controller.showConfirmPassword.value,
              widget: InkWell(
                child: Container(
                  child: Icon(
                    controller.showConfirmPassword.value
                        ? const IconData(0xecb3, fontFamily: 'MIcon')
                        : const IconData(0xecb5, fontFamily: 'MIcon'),
                    color: Get.isDarkMode
                        ? Color.fromRGBO(130, 139, 150, 1)
                        : Color.fromRGBO(179, 179, 179, 1),
                    size: 24.sp,
                  ),
                ),
                onTap: () {
                  controller.showConfirmPassword.value =
                      !controller.showConfirmPassword.value;
                },
              ),
              onChange: (text) {
                controller.currentPassword.value = text;
              },
            ),
            ProfileTextField(
              text: "New password".tr,
              value: controller.newPassword.value,
              isObscureText: controller.showNewPassword.value,
              widget: InkWell(
                child: Container(
                  child: Icon(
                    controller.showNewPassword.value
                        ? const IconData(0xecb3, fontFamily: 'MIcon')
                        : const IconData(0xecb5, fontFamily: 'MIcon'),
                    color: Get.isDarkMode
                        ? Color.fromRGBO(130, 139, 150, 1)
                        : Color.fromRGBO(179, 179, 179, 1),
                    size: 24.sp,
                  ),
                ),
                onTap: () {
                  controller.showNewPassword.value =
                      !controller.showNewPassword.value;
                },
              ),
              onChange: (text) {
                controller.newPassword.value = text;
              },
            ),
            ProfileTextField(
              text: "Confirm password".tr,
              value: controller.newPasswordConfirm.value,
              isObscureText: controller.showNewPasswordConfirm.value,
              widget: InkWell(
                child: Container(
                  child: Icon(
                    controller.showNewPasswordConfirm.value
                        ? const IconData(0xecb3, fontFamily: 'MIcon')
                        : const IconData(0xecb5, fontFamily: 'MIcon'),
                    color: Get.isDarkMode
                        ? Color.fromRGBO(130, 139, 150, 1)
                        : Color.fromRGBO(179, 179, 179, 1),
                    size: 24.sp,
                  ),
                ),
                onTap: () {
                  controller.showNewPasswordConfirm.value =
                      !controller.showNewPasswordConfirm.value;
                },
              ),
              onChange: (text) {
                controller.newPasswordConfirm.value = text;
              },
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                if (controller.newPassword.value.length < 6) {
                  Get.bottomSheet(ErrorAlert(
                    message:
                        "Password length should be at least 6 characters".tr,
                    onClose: () {
                      Get.back();
                    },
                  ));
                } else if (controller.newPassword.value ==
                    controller.newPasswordConfirm.value) {
                  if (controller.currentPassword.value ==
                      controller.user.value!.password) {
                    controller.user.value!.password =
                        controller.newPassword.value;
                    controller.user.refresh();
                    controller.checkUser();
                    Get.back();
                  } else
                    Get.bottomSheet(ErrorAlert(
                      message: "Current password is wrong".tr,
                      onClose: () {
                        Get.back();
                      },
                    ));
                } else {
                  Get.bottomSheet(ErrorAlert(
                    message:
                        "New password and New password confirm mismatch".tr,
                    onClose: () {
                      Get.back();
                    },
                  ));
                }
              },
              child: Container(
                width: 1.sw - 30,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromRGBO(69, 165, 36, 1)),
                alignment: Alignment.center,
                child: Text(
                  "Update password".tr,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                      letterSpacing: -0.4,
                      color: Color.fromRGBO(255, 255, 255, 1)),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      );
    });
  }
}
