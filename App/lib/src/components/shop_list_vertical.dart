import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/empty.dart';
import 'package:githubit/src/components/shadows/shopListVerticalItemShadow.dart';
import 'package:githubit/src/components/shop_categories_list_widget.dart';
import 'package:githubit/src/components/shop_list_vertical_item.dart';
import 'package:githubit/src/controllers/shop_controller.dart';

class ShopListVertical extends GetView<ShopController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
          padding: EdgeInsets.only(top: 30, bottom: 30),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "All shops".tr,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      letterSpacing: -1,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                  InkWell(
                    child: Text(
                      "View on map".tr,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          letterSpacing: -0.5,
                          color: Color.fromRGBO(53, 105, 184, 1)),
                    ),
                    onTap: () => Get.toNamed("/shopsLocation"),
                  ),
                ],
              ),
            ),
            ShopCategoriesLisWidget(),
            Container(
                width: 1.sw,
                margin: EdgeInsets.only(bottom: 90),
                child: !controller.loading.value
                    ? controller.shopList.length > 0
                        ? Column(
                            children: controller.shopList.map((shop) {
                            int index = controller.shopList
                                .indexWhere((element) => element == shop);

                            return InkWell(
                              child: ShopListVerticalItem(
                                name: shop['language']['name'],
                                description: shop['language']['description'],
                                rating: shop['rating'].toString(),
                                openHour: shop['open_hour'].substring(0, 5),
                                closeHour: shop['close_hour'].substring(0, 5),
                                logo: shop['logo_url'],
                                isLast:
                                    index == (controller.shopList.length - 1),
                              ),
                              onTap: () => controller.addToSavedShop(shop),
                            );
                          }).toList())
                        : Empty(message: "No shops".tr)
                    : Column(
                        children: <Widget>[
                          ShopListVerticalItemShadow(),
                          ShopListVerticalItemShadow(),
                          ShopListVerticalItemShadow(),
                          ShopListVerticalItemShadow()
                        ],
                      ))
          ]));
    });
  }
}
