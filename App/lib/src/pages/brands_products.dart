import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/category_products_item.dart';
import 'package:githubit/src/components/empty.dart';
import 'package:githubit/src/components/filter.dart';
import 'package:githubit/src/components/search_input.dart';
import 'package:githubit/src/components/shadows/category_product_item_shadow.dart';
import 'package:githubit/src/controllers/brands_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:githubit/src/models/product.dart';

class BrandsProducts extends GetView<BrandsController> {
  Widget loading() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CategoryProductItemShadow(),
            CategoryProductItemShadow()
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CategoryProductItemShadow(),
            CategoryProductItemShadow()
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String name = controller.activeBrand.value.name!;
      int id = controller.activeBrand.value.id!;
      var statusBarHeight = MediaQuery.of(context).padding.top;
      var appBarHeight = AppBar().preferredSize.height;

      return Scaffold(
          backgroundColor: Get.isDarkMode
              ? Color.fromRGBO(19, 20, 21, 1)
              : Color.fromRGBO(243, 243, 240, 1),
          appBar: PreferredSize(
              preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
              child: AppBarCustom(
                title: "$name",
                hasBack: true,
                onBack: () {
                  controller.productController.clearFilter();
                  controller.load.value = true;
                  controller.brandProductsList[id] = [];
                },
              )),
          body: Scrollbar(
            child: SingleChildScrollView(
              controller: controller.scrollController,
              child: Column(
                children: <Widget>[
                  SearchInput(
                    title: "Search products".tr,
                    onChange: (text) {
                      controller.brandProductsList[id] = [];
                      controller.brandProductsList.refresh();
                      controller.productController.searchText.value = text;
                      controller.load.value = true;
                    },
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) {
                            return Filter(
                              isBrandShow: false,
                              onPress: () {
                                controller.load.value = true;
                                controller.brandProductsList[id] = [];
                                controller.brandProductsList.refresh();
                                Get.back();
                              },
                            );
                          });
                    },
                  ),
                  FutureBuilder<List<Product>>(
                    future: controller.getBrandsProducts(id, 10),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          (!controller.load.value ||
                              controller.brandProductsList[id]!.length > 0)) {
                        List<Product> products =
                            controller.brandProductsList[id]!;

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

                        return row.length == 0
                            ? Empty(message: "No products".tr)
                            : Container(
                                width: 1.sw,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  children: row.toList(),
                                ));
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: loading(),
                      );
                    },
                  ),
                  if (controller.load.value)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: loading(),
                    )
                ],
              ),
            ),
          ));
    });
  }
}
