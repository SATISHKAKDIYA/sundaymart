import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/home_tabs_item.dart';
import 'package:githubit/src/controllers/category_controller.dart';

class HomeTabs extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 34,
        width: 1.sw,
        margin: EdgeInsets.only(top: 32),
        child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            itemCount: controller.tabs.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Obx(() => HomeTabsItem(
                    title: controller.tabs[index],
                    isActive: controller.tabIndex.value == index,
                    onTap: () {
                      controller.onChangeProductType(index);
                    },
                  ));
            }));
  }
}
