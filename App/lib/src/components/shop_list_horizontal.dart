import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/shop_list_horizontal_item.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/shop.dart';

class ShopListHorizontal extends GetView<ShopController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<Shop> shops = controller.savedShopList;
      return Container(
        padding: EdgeInsets.only(
            top: shops.length > 0 ? 30 : 0, bottom: shops.length > 0 ? 30 : 0),
        child: Column(
          children: <Widget>[
            if (shops.length > 0)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Saved shop".tr,
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
                  ],
                ),
              ),
            if (shops.length > 0)
              Container(
                width: 1.sw,
                height: 255,
                margin: EdgeInsets.only(top: 15),
                child: ListView.builder(
                    itemCount: shops.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 15),
                    itemBuilder: (BuildContext context, index) {
                      Shop shop = shops[index];

                      return InkWell(
                          child: ShopListHorizontalItem(
                            name: shop.name,
                            description: shop.description,
                            backImageUrl: shop.backImageUrl,
                            openHour: shop.openHours,
                            closeHour: shop.closeHours,
                          ),
                          onTap: () => controller.setDefaultShop(index));
                    }),
              )
          ],
        ),
      );
    });
  }
}
