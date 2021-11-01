import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/main_category_item.dart';
import 'package:githubit/src/controllers/category_controller.dart';
import 'package:githubit/src/models/category.dart';

class Categories extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      appBar: PreferredSize(
          preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
          child: AppBarCustom(
            title: "Categories".tr,
            hasBack: false,
          )),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Obx(() {
          List<Category> categories = controller.categoryList;

          List<Widget> row = [];
          List<Widget> subRow = [];

          for (int i = 0; i < categories.length; i++) {
            subRow.add(MainCategoryItem(
              category: categories[i],
              isLast: (i + 1) % 3 == 0,
            ));

            if ((i + 1) % 3 == 0 || (i + 1) == categories.length) {
              row.add(Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: subRow.toList(),
              ));

              subRow = [];
            }
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: row.toList(),
          );
        }),
      ),
    );
  }
}
