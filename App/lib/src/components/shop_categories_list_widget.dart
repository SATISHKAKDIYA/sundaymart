import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/shop_category_item.dart';
import 'package:githubit/src/controllers/shop_controller.dart';

class ShopCategoriesLisWidget extends StatelessWidget {
  final ShopController controller = Get.put(ShopController());

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        height: 35,
        margin: EdgeInsets.only(top: 15, bottom: 6),
        child: ListView.builder(
            itemCount: controller.categoryList.length + 1,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 15),
            itemBuilder: (BuildContext context, index) {
              if (index == 0)
                return ShopCategoryItem(
                  title: "All".tr,
                  isActive: controller.shopCategory.value == -1,
                  id: -1,
                  onClick: () => controller.onChangeShopCategory(-1),
                );

              Map<String, dynamic> data = controller.categoryList[index - 1];
              return ShopCategoryItem(
                title: "${data['language']['name']}",
                isActive: controller.shopCategory.value == data['id'],
                id: data['id'],
                onClick: () => controller.onChangeShopCategory(data['id']),
              );
            }));
  }
}
