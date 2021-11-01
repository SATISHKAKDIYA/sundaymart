import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/cart_item.dart';
import 'package:githubit/src/components/cart_summary.dart';
import 'package:githubit/src/components/coupon.dart';
import 'package:githubit/src/components/empty.dart';
import 'package:githubit/src/controllers/cart_controller.dart';

class Cart extends GetView<CartController> {
  void showSheet(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return CartSummary(
              scrollController: controller,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var statusBarHeight = MediaQuery.of(context).padding.top;
      var appBarHeight = AppBar().preferredSize.height;

      return Scaffold(
        backgroundColor: Get.isDarkMode
            ? Color.fromRGBO(19, 20, 21, 1)
            : Color.fromRGBO(243, 243, 240, 1),
        appBar: PreferredSize(
            preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
            child: AppBarCustom(
              title: "Cart".tr,
              hasBack: true,
            )),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 120),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "My order".tr,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          letterSpacing: -1,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1)),
                    ),
                    Coupon()
                  ],
                ),
              ),
              Column(
                children: controller.cartProducts.map((element) {
                  return CartItem(
                    product: element,
                  );
                }).toList(),
              ),
              if (controller.cartProducts.length == 0)
                Empty(message: "No products in cart".tr)
            ],
          ),
        ),
        extendBody: true,
        bottomNavigationBar: Container(
            height: 100,
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
                  height: 100,
                  width: 1.sw,
                  padding: EdgeInsets.only(left: 15, right: 15),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Total amount".tr,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                letterSpacing: -0.4,
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(130, 139, 150, 1)
                                    : Color.fromRGBO(136, 136, 126, 1)),
                          ),
                          Text(
                            "${controller.calculateAmount().toStringAsFixed(2)}",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                fontSize: 28.sp,
                                height: 1.3,
                                letterSpacing: -0.4,
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(0, 0, 0, 1)),
                          ),
                        ],
                      ),
                      if (controller.cartProducts.length > 0)
                        InkWell(
                          onTap: () {
                            showSheet(context);
                          },
                          child: Container(
                            height: 60,
                            width: 0.42.sw,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(69, 165, 36, 1),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Checkout".tr,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  color: Color.fromRGBO(255, 255, 255, 1)),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            )),
      );
    });
  }
}
