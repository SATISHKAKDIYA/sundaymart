import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/home_category_product_item.dart';
import 'package:githubit/src/components/shadows/home_category_product_item_shadow.dart';
import 'package:githubit/src/controllers/category_controller.dart';
import 'package:githubit/src/models/category.dart';
import 'package:githubit/src/models/product.dart';

class HomeCategoryProducts extends GetView<CategoryController> {
  final String? name;
  final String? imageUrl;
  final int? id;
  final bool? isSimilar;

  HomeCategoryProducts(
      {this.name, this.id, this.imageUrl, this.isSimilar = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: isSimilar! ? 0 : 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "$name",
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      letterSpacing: -1,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1)),
                ),
                InkWell(
                  child: Text(
                    "View more".tr,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        letterSpacing: -0.5,
                        color: Color.fromRGBO(53, 105, 184, 1)),
                  ),
                  onTap: () {
                    controller.activeCategory.value =
                        Category(id: id, imageUrl: imageUrl, name: name);
                    controller.productController.clearFilter();
                    controller.load.value = true;
                    controller.categoryProductList[id!] = [];
                    Get.toNamed("/categoryProducts");
                  },
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 18),
              height: 332,
              width: 1.sw,
              child: FutureBuilder<List<Product>>(
                future: controller.getCategoryProducts(id!, true),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Product> categoriesProducts = snapshot.data!;

                    return ListView.builder(
                        itemCount: categoriesProducts.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                            horizontal: isSimilar! ? 0 : 15),
                        itemBuilder: (context, index) {
                          Product item = categoriesProducts[index];

                          return HomeCategoryProductItem(
                            product: item,
                            iSimilar: isSimilar,
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      padding:
                          EdgeInsets.symmetric(horizontal: isSimilar! ? 0 : 15),
                      itemBuilder: (context, index) {
                        return HomeCategoryProductItemShadow();
                      });
                },
              ))
        ],
      ),
    );
  }
}
