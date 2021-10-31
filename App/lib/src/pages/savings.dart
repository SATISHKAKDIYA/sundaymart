import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/category_products_item.dart';
import 'package:githubit/src/components/empty.dart';
import 'package:githubit/src/components/shadows/category_product_item_shadow.dart';
import 'package:githubit/src/controllers/savings_controller.dart';
import 'package:githubit/src/models/product.dart';

class Savings extends GetView<SavingsController> {
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
            title: "Savings".tr,
            hasBack: false,
          )),
      body: Column(
        children: <Widget>[
          Container(
            width: 1.sw,
            height: 60,
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Color.fromRGBO(26, 34, 44, 1)
                    : Color.fromRGBO(249, 249, 246, 1)),
            child: TabBar(
                controller: controller.tabController,
                indicatorColor: Color.fromRGBO(69, 165, 36, 1),
                indicatorWeight: 2,
                labelColor: Get.isDarkMode
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(0, 0, 0, 1),
                unselectedLabelColor: Get.isDarkMode
                    ? Color.fromRGBO(130, 139, 150, 1)
                    : Color.fromRGBO(136, 136, 126, 1),
                onTap: (index) {
                  controller.setTab(index);
                },
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  letterSpacing: -0.4,
                ),
                tabs: [
                  Tab(
                    text: "Discounts".tr,
                  ),
                  Tab(
                    text: "Coupons".tr,
                  )
                ]),
          ),
          Obx(() => Container(
                child: [
                  Container(
                      width: 1.sw,
                      height: 1.sh - 165,
                      child: FutureBuilder<List<Product>>(
                        future: controller.getDiscount(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Product> products = snapshot.data ?? [];

                            if (products.length == 0)
                              return Empty(message: "No discount".tr);

                            List<Widget> row = [];
                            List<Widget> subRow = [];

                            for (int i = 0; i < products.length; i++) {
                              subRow.add(
                                  CategoryProductItem(product: products[i]));

                              if ((i + 1) % 2 == 0 ||
                                  (i + 1) == products.length) {
                                row.add(Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: subRow.toList(),
                                ));

                                subRow = [];
                              }
                            }

                            return ListView.builder(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 80),
                                itemCount: row.length,
                                itemBuilder: (context, index) {
                                  return row[index];
                                });
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          return ListView.builder(
                            itemCount: 3,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            itemBuilder: (context, index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CategoryProductItemShadow(),
                                  CategoryProductItemShadow()
                                ],
                              );
                            },
                          );
                        },
                      )),
                  Container(
                      width: 1.sw,
                      height: 1.sh - 165,
                      padding: EdgeInsets.only(bottom: 60),
                      child: Scrollbar(
                        child: FutureBuilder<List<Product>>(
                          future: controller.getCoupons(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Product> products = snapshot.data ?? [];

                              if (products.length == 0)
                                return Empty(message: "No coupon products".tr);

                              List<Widget> row = [];
                              List<Widget> subRow = [];

                              for (int i = 0; i < products.length; i++) {
                                subRow.add(CategoryProductItem(
                                  product: products[i],
                                ));

                                if ((i + 1) % 2 == 0 ||
                                    (i + 1) == products.length) {
                                  row.add(Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: subRow.toList(),
                                  ));

                                  subRow = [];
                                }
                              }

                              return ListView.builder(
                                  controller: controller.controllerCoupon,
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 10, bottom: 80),
                                  itemCount: row.length,
                                  itemBuilder: (context, index) {
                                    return row[index];
                                  });
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }

                            return ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CategoryProductItemShadow(),
                                    CategoryProductItemShadow()
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      )),
                ][controller.tabIndex.value],
              )),
        ],
      ),
    );
  }
}
