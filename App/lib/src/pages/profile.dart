import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/proccess_full.dart';
import 'package:githubit/src/components/profile_dot.dart';
import 'package:githubit/src/components/profile_menu_item.dart';
import 'package:githubit/src/controllers/auth_controller.dart';

class ProfilePage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Get.isDarkMode
            ? Color.fromRGBO(19, 20, 21, 1)
            : Color.fromRGBO(243, 243, 240, 1),
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                child: Icon(
                  const IconData(0xeb99, fontFamily: 'MIcon'),
                  color: Get.isDarkMode
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(0, 0, 0, 1),
                  size: 24,
                ),
                padding: EdgeInsets.only(right: 20),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 0.24.sw + 10,
                      height: 0.24.sw + 10,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 10,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(37, 48, 63, 1)
                                  : Color.fromRGBO(255, 255, 255, 0.35)),
                          borderRadius: BorderRadius.circular(
                            0.24.sw,
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          0.24.sw,
                        ),
                        child: controller.user.value!.imageUrl!.length > 4
                            ? CachedNetworkImage(
                                width: 0.24.sw,
                                height: 0.24.sw,
                                fit: BoxFit.fill,
                                imageUrl:
                                    "$GLOBAL_IMAGE_URL${controller.image.value}",
                                placeholder: (context, url) => Container(
                                  width: 0.24.sw,
                                  height: 0.24.sw,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    const IconData(0xee4b, fontFamily: 'MIcon'),
                                    color: Color.fromRGBO(233, 233, 230, 1),
                                    size: 20.sp,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : Container(
                                width: 0.24.sw,
                                height: 0.24.sw,
                                child: Icon(
                                  const IconData(0xf25c, fontFamily: 'MIcon'),
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1),
                                  size: 40.sp,
                                ),
                              ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      width: 0.76.sw - 90,
                      child: Text(
                        "${controller.user.value!.name} \n${controller.user.value!.surname}",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 30.sp,
                          letterSpacing: -1,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                height: 60,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(69, 165, 36, 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 25),
                      child: Text(
                        "${"Balance".tr}\n${controller.user.value!.earnMark} ${"ball".tr}",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            height: 1.6,
                            color: Color.fromRGBO(255, 255, 255, 1)),
                      ),
                    ),
                    Container(
                      width: 0.36.sw,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ProfileDot(),
                          ProfileDot(),
                          ProfileDot(),
                          ProfileDot()
                        ],
                      ),
                    ),
                    Text(
                      "+50 ${"ball".tr}",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                          height: 1.4,
                          color: Color.fromRGBO(255, 255, 255, 1)),
                    ),
                    Container(
                      height: 46,
                      width: 42,
                      margin: EdgeInsets.only(right: 7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color.fromRGBO(54, 126, 28, 1)),
                      child: Icon(
                        const IconData(0xf1a8, fontFamily: 'MIcon'),
                        size: 24.sp,
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    )
                  ],
                ),
              ),
              ProfileMenuItem(
                title: "Order history".tr,
                onClick: () => Get.toNamed("/orderHistory"),
                icon: const IconData(0xecec, fontFamily: 'MIcon'),
                rightWidget: FutureBuilder<int>(
                    future: controller.orderController
                        .getOrderCount(controller.user.value!.id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          child: Text(
                            "${snapshot.data}",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                                letterSpacing: -0.4,
                                color: Color.fromRGBO(255, 255, 255, 1)),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color.fromRGBO(255, 161, 0, 1)),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return Container();
                    }),
              ),
              ProfileMenuItem(
                title: "Liked products".tr,
                onClick: () => Get.toNamed("/liked"),
                icon: const IconData(0xee0e, fontFamily: 'MIcon'),
              ),
              ProfileMenuItem(
                title: "Profile setting".tr,
                onClick: () => Get.toNamed("/profileSettings"),
                icon: const IconData(0xf25b, fontFamily: 'MIcon'),
                rightWidget: Container(
                    width: 142,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: RichText(
                            text: TextSpan(
                                text: "${"Completed".tr} — ",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  letterSpacing: -0.4,
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "${controller.profilePercentage.value}%",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12.sp,
                                        letterSpacing: -0.4,
                                        color: Get.isDarkMode
                                            ? Color.fromRGBO(255, 255, 255, 1)
                                            : Color.fromRGBO(0, 0, 0, 1),
                                      ))
                                ]),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ProccessFull(
                              isFilled: controller.profilePercentage.value > 10,
                            ),
                            ProccessFull(
                              isFilled: controller.profilePercentage.value > 25,
                            ),
                            ProccessFull(
                              isFilled: controller.profilePercentage.value > 40,
                            ),
                            ProccessFull(
                              isFilled: controller.profilePercentage.value > 50,
                            ),
                            ProccessFull(
                              isFilled: controller.profilePercentage.value > 60,
                            ),
                            ProccessFull(
                              isFilled: controller.profilePercentage.value > 75,
                            ),
                            ProccessFull(
                              isFilled: controller.profilePercentage.value > 90,
                            ),
                            ProccessFull(
                              isFilled:
                                  controller.profilePercentage.value == 100,
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              ProfileMenuItem(
                title: "Setting".tr,
                onClick: () => Get.toNamed("/settings"),
                icon: const IconData(0xf0e7, fontFamily: 'MIcon'),
              ),
              ProfileMenuItem(
                title: "Q&A".tr,
                onClick: () => Get.toNamed("/qa"),
                icon: const IconData(0xef45, fontFamily: 'MIcon'),
              ),
              ProfileMenuItem(
                title: "About".tr,
                onClick: () => Get.toNamed("/about"),
                icon: const IconData(0xee58, fontFamily: 'MIcon'),
              ),
              ProfileMenuItem(
                title: "Exit".tr,
                onClick: () => controller.logout(),
                icon: const IconData(0xeedb, fontFamily: 'MIcon'),
                noUnderline: true,
              ),
            ],
          ),
        ),
        // floatingActionButton: InkWell(
        //   onTap: () => Get.toNamed("/chat"),
        //   child: Container(
        //     height: 60,
        //     width: 60,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(30),
        //         boxShadow: <BoxShadow>[
        //           BoxShadow(
        //               offset: Offset(0, 20),
        //               blurRadius: 40,
        //               spreadRadius: 0,
        //               color: Color.fromRGBO(29, 105, 3, 0.27))
        //         ],
        //         color: Color.fromRGBO(69, 165, 36, 1)),
        //     child: Icon(
        //       const IconData(0xef45, fontFamily: 'MIcon'),
        //       color: Color.fromRGBO(255, 255, 255, 1),
        //       size: 24.sp,
        //     ),
        //   ),
        // ),
      );
    });
  }
}
