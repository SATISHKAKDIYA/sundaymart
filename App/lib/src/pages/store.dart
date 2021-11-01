import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/custom_btn.dart';
import 'package:githubit/src/components/search_input.dart';
import 'package:githubit/src/components/shop_list_horizontal.dart';
import 'package:githubit/src/components/shop_list_vertical.dart';
import 'package:githubit/src/components/tab_button.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/address.dart';
import 'package:githubit/src/models/user.dart';

class StorePage extends GetView<ShopController> {
  @override
  Widget build(BuildContext context) {
    User? user = controller.authController.user.value;
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      appBar: PreferredSize(
        preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
        child: Container(
          width: 1.sw,
          height: statusBarHeight + appBarHeight,
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Get.isDarkMode
                        ? Color.fromRGBO(23, 27, 32, 0.13)
                        : Color.fromRGBO(169, 169, 150, 0.13))
              ],
              color: Get.isDarkMode
                  ? Color.fromRGBO(37, 48, 63, 1)
                  : Color.fromRGBO(255, 255, 255, 1)),
          padding: EdgeInsets.only(left: 15, right: 15, top: statusBarHeight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: Color.fromRGBO(69, 165, 36, 1)),
                child: Icon(
                  const IconData(0xef09, fontFamily: 'MIcon'),
                  size: 20.sp,
                  color: Colors.white,
                ),
              ),
              Obx(() {
                Address address =
                    controller.addressController.getDefaultAddress();

                return Container(
                  height: 34,
                  width: 1.sw - 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Delivery address".tr,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          letterSpacing: -0.5,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                      Container(
                        width: 1.sw - 160,
                        child: Text(
                          "${address.address}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w300,
                              fontSize: 14.sp,
                              letterSpacing: -0.5,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(130, 139, 150, 1)
                                  : Color.fromRGBO(136, 136, 126, 1)),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              CustomButton(
                title: "Change".tr,
                height: 30,
                width: 0.19.sw,
                backColor: Colors.black,
                onPress: () => Get.toNamed("/locationList"),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SearchInput(
              title: "Search stores".tr,
              hasSuffix: false,
            ),
            ShopListHorizontal(),
            ShopListVertical()
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
          height: 80,
          width: 1.sw,
          decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? Color.fromRGBO(37, 48, 63, 0.7)
                  : Color.fromRGBO(255, 255, 255, 0.7)),
          alignment: Alignment.topCenter,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
              child: Container(
                height: 80,
                width: 1.sw,
                padding:
                    EdgeInsets.only(top: 18, bottom: 22, left: 28, right: 43),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Obx(() => Container(
                          width: 0.66.sw,
                          height: 40,
                          child: TabBar(
                              indicatorColor: Colors.transparent,
                              controller: controller.tabController,
                              indicatorSize: TabBarIndicatorSize.label,
                              labelPadding: EdgeInsets.all(0),
                              onTap: (index) {
                                controller.onChangeDeliveryType(index + 1);
                              },
                              tabs: [
                                Tab(
                                  child: TabButton(
                                    isActive:
                                        controller.deliveryType.value == 1,
                                    title: "Delivery".tr,
                                    icon: controller.deliveryType.value == 1
                                        ? const IconData(0xf1e1,
                                            fontFamily: 'MIcon')
                                        : const IconData(0xf1e2,
                                            fontFamily: 'MIcon'),
                                  ),
                                ),
                                Tab(
                                  child: TabButton(
                                    isActive:
                                        controller.deliveryType.value == 2,
                                    title: "Pickup".tr,
                                    icon: controller.deliveryType.value == 2
                                        ? const IconData(0xf115,
                                            fontFamily: 'MIcon')
                                        : const IconData(0xf116,
                                            fontFamily: 'MIcon'),
                                    isSecond: true,
                                  ),
                                )
                              ]),
                        )),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(130, 139, 150, 0.1)
                                  : Color.fromRGBO(136, 136, 126, 0.1)),
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                          onTap: () {
                            Get.toNamed("/profile");
                          },
                          child: user!.imageUrl!.length > 4
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.fill,
                                    imageUrl:
                                        "$GLOBAL_IMAGE_URL${user.imageUrl}",
                                    placeholder: (context, url) => Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        const IconData(0xee4b,
                                            fontFamily: 'MIcon'),
                                        color: Color.fromRGBO(233, 233, 230, 1),
                                        size: 20.sp,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ))
                              : Icon(
                                  const IconData(0xf25c, fontFamily: 'MIcon'),
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1),
                                  size: 20,
                                )),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
