import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/category_products_item.dart';
import 'package:githubit/src/components/empty.dart';
import 'package:githubit/src/controllers/product_controller.dart';
import 'package:githubit/src/models/product.dart';

class Liked extends GetView<ProductController> {
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
              title: "Liked products".tr,
              hasBack: true,
            )),
        body: SingleChildScrollView(child: Obx(() {
          List<Product> products = controller.likedProducts;

          List<Widget> row = [];
          List<Widget> subRow = [];

          for (int i = 0; i < products.length; i++) {
            subRow.add(CategoryProductItem(
              product: products[i],
            ));

            if ((i + 1) % 2 == 0 || (i + 1) == products.length) {
              row.add(Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: subRow.toList(),
              ));

              subRow = [];
            }
          }

          return row.length > 0
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: row.toList(),
                  ))
              : Empty(
                  message: "No liked products".tr,
                );
        })));
  }
}
