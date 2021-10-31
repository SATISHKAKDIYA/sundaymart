import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/controllers/notification_controller.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/shop.dart';

class HomeSilverBar extends StatelessWidget {
  final ShopController shopController = Get.put(ShopController());
  final NotificationController notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    Shop? shop = shopController.defaultShop.value;

    return SliverAppBar(
      expandedHeight: 300,
      floating: false,
      automaticallyImplyLeading: false,
      pinned: true,
      shadowColor: Color.fromRGBO(169, 169, 150, 0.13),
      backgroundColor:
          Get.isDarkMode ? Color.fromRGBO(23, 27, 32, 0.13) : Colors.white,
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double height = constraints.biggest.height - 100;

        return FlexibleSpaceBar(
          centerTitle: true,
          background: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: "$GLOBAL_IMAGE_URL${shop!.backImageUrl}",
            placeholder: (context, url) => Container(
              alignment: Alignment.center,
              child: Icon(
                const IconData(0xee4b, fontFamily: 'MIcon'),
                color: Color.fromRGBO(233, 233, 230, 1),
                size: 20.sp,
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          titlePadding: EdgeInsets.zero,
          title: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: 1.0,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                Widget>[
              Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: height > 0 ? 10 : 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image(
                              image: CachedNetworkImageProvider(
                                  "$GLOBAL_IMAGE_URL${shop.logoUrl}"),
                              height: 44,
                              width: 44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                              width: 1.sw - 240,
                              padding: EdgeInsets.only(left: 8),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed("/store");
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          Text(
                                            "${shop.name}",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: -1,
                                                fontSize: 16.sp,
                                                color: height > 0
                                                    ? Colors.white
                                                    : Get.isDarkMode
                                                        ? Color.fromRGBO(
                                                            255, 255, 255, 1)
                                                        : Color.fromRGBO(
                                                            0, 0, 0, 1)),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 8),
                                            alignment: Alignment.center,
                                            child: Icon(
                                              const IconData(0xea4e,
                                                  fontFamily: "MIcon"),
                                              color: height > 0
                                                  ? Colors.white
                                                  : Get.isDarkMode
                                                      ? Color.fromRGBO(
                                                          255, 255, 255, 1)
                                                      : Color.fromRGBO(
                                                          0, 0, 0, 1),
                                              size: 16.sp,
                                            ),
                                          )
                                        ]),
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "${"Working hours".tr} ${shop.openHours} — ${shop.closeHours}",
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: -0.4,
                                              fontSize: 10.sp,
                                              color: height > 0
                                                  ? Colors.white
                                                  : Get.isDarkMode
                                                      ? Color.fromRGBO(
                                                          255, 255, 255, 1)
                                                      : Color.fromRGBO(
                                                          0, 0, 0, 1)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Icon(
                                            const IconData(0xee58,
                                                fontFamily: 'MIcon'),
                                            size: 12.sp,
                                            color: height > 0
                                                ? Colors.white
                                                : Get.isDarkMode
                                                    ? Color.fromRGBO(
                                                        255, 255, 255, 1)
                                                    : Color.fromRGBO(
                                                        0, 0, 0, 1),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                      Obx(() {
                        return Container(
                          height: 30,
                          width: 30,
                          child: Stack(
                            children: <Widget>[
                              TextButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all<
                                              EdgeInsetsGeometry>(
                                          EdgeInsets.all(0))),
                                  onPressed: () =>
                                      Get.toNamed("/notifications"),
                                  child: Icon(
                                    const IconData(0xef99, fontFamily: 'MIcon'),
                                    size: 18.sp,
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(136, 136, 126, 1),
                                  )),
                              if (notificationController
                                      .unreadedNotifications.value >
                                  0)
                                Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              Color.fromRGBO(255, 184, 0, 1)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${notificationController.unreadedNotifications.value}",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10.sp,
                                            letterSpacing: -0.4,
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1)),
                                      ),
                                    ))
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Color.fromRGBO(19, 20, 21, 1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: <BoxShadow>[
                              if (height > 0)
                                BoxShadow(
                                    offset: Offset(0, 0),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    color: Color.fromRGBO(78, 72, 72, 0.64))
                            ],
                          ),
                        );
                      })
                    ],
                  )),
              if (height - 60 > 0)
                SizedBox(
                  height: height - 207 > 0 ? height - 207 : 0,
                ),
              if (height - 60 > 0)
                Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: height > 0 ? 10 : 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Container(
                                  width: 0.19.sw,
                                  height: height - 192 > 0 ? height - 192 : 0,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.17),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        const IconData(0xf18e,
                                            fontFamily: 'MIcon'),
                                        size: 12.sp,
                                        color: Color.fromRGBO(255, 161, 0, 1),
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        "${shop.rating}",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            letterSpacing: -0.4,
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1)),
                                      )
                                    ],
                                  ),
                                ))),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Container(
                                  //width: 0.40.sw,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  height: height - 192 > 0 ? height - 192 : 0,
                                  decoration: BoxDecoration(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.17),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      if (shop.deliveryType == 3 ||
                                          shop.deliveryType == 1)
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                const IconData(0xf1e1,
                                                    fontFamily: 'MIcon'),
                                                color: Colors.white,
                                                size: 12.sp,
                                              ),
                                              SizedBox(
                                                width: 7,
                                              ),
                                              Text(
                                                "Delivery".tr,
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10.sp,
                                                    letterSpacing: -0.5,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (shop.deliveryType == 3)
                                        SizedBox(
                                          width: 10,
                                        ),
                                      if (shop.deliveryType == 3)
                                        VerticalDivider(
                                          width: 1,
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.12),
                                        ),
                                      if (shop.deliveryType == 3)
                                        SizedBox(
                                          width: 10,
                                        ),
                                      if (shop.deliveryType == 3 ||
                                          shop.deliveryType == 2)
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                const IconData(0xf115,
                                                    fontFamily: 'MIcon'),
                                                color: Colors.white,
                                                size: 12.sp,
                                              ),
                                              SizedBox(
                                                width: 7,
                                              ),
                                              Text(
                                                "Pickup".tr,
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10.sp,
                                                    letterSpacing: -0.5,
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1)),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                )))
                      ],
                    )),
              SizedBox(
                height: 10,
              ),
              if (height > 20)
                Container(
                  margin: EdgeInsets.only(top: 15),
                  width: 1.sw,
                  height: 40,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          bottom: 0,
                          left: 0,
                          child: Container(
                            width: 1.sw,
                            height: 25,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(19, 20, 21, 1)
                                : Color.fromRGBO(243, 243, 240, 1),
                          )),
                      Container(
                          height: 40,
                          width: 1.sw - 30,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(26, 34, 44, 1)
                                  : Color.fromRGBO(255, 255, 255, 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        const IconData(0xee58,
                                            fontFamily: 'MIcon'),
                                        size: 16.sp,
                                        color: Color.fromRGBO(136, 136, 126, 1),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Market info".tr,
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            letterSpacing: -0.5,
                                            color: Get.isDarkMode
                                                ? Color.fromRGBO(
                                                    130, 139, 150, 1)
                                                : Color.fromRGBO(
                                                    136, 136, 126, 1)),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () => Get.toNamed("/shopInfo",
                                    arguments: {"tab_index": 0}),
                              ),
                              VerticalDivider(
                                width: 1,
                                color: Color.fromRGBO(243, 243, 240, 1),
                              ),
                              InkWell(
                                  onTap: () => Get.toNamed("/shopInfo",
                                      arguments: {"tab_index": 1}),
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          const IconData(0xef17,
                                              fontFamily: 'MIcon'),
                                          size: 16.sp,
                                          color:
                                              Color.fromRGBO(136, 136, 126, 1),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Delivery time".tr,
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10.sp,
                                              letterSpacing: -0.5,
                                              color: Get.isDarkMode
                                                  ? Color.fromRGBO(
                                                      130, 139, 150, 1)
                                                  : Color.fromRGBO(
                                                      136, 136, 126, 1)),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          )),
                    ],
                  ),
                ),
            ]),
          ),
        );
      }),
    );
  }
}
