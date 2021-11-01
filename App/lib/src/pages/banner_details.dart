import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/banner_item.dart';
import 'package:githubit/src/components/category_products_item.dart';
import 'package:githubit/src/components/filter.dart';
import 'package:githubit/src/components/search_input.dart';
import 'package:githubit/src/components/shadows/category_product_item_shadow.dart';
import 'package:githubit/src/controllers/banner_controller.dart';
import 'package:githubit/src/models/banner.dart' as BannerModel;
import 'package:githubit/src/models/product.dart';

class BannerDetails extends GetView<BannerController> {
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
      BannerModel.Banner banner = controller.activeBanner.value;
      var statusBarHeight = MediaQuery.of(context).padding.top;
      var appBarHeight = AppBar().preferredSize.height;

      return Scaffold(
        backgroundColor: Get.isDarkMode
            ? Color.fromRGBO(19, 20, 21, 1)
            : Color.fromRGBO(243, 243, 240, 1),
        appBar: PreferredSize(
            preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
            child: AppBarCustom(
              title: "${banner.title}",
              hasBack: true,
              onBack: () {
                controller.productController.clearFilter();
              },
            )),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SearchInput(
                title: "Search products".tr,
                onChange: (text) {
                  controller.bannerProducts.value = [];
                  controller.bannerProducts.refresh();
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
                          onPress: () {
                            controller.load.value = true;
                            controller.bannerProducts.value = [];
                            controller.bannerProducts.refresh();
                            Get.back();
                          },
                        );
                      });
                },
              ),
              SizedBox(
                height: 20,
              ),
              BannerItem(
                banner: banner,
                isDetail: false,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Html(data: banner.description),
              ),
              Container(
                  width: 1.sw,
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: FutureBuilder<List<Product>>(
                            future: controller.getBannerProducts(banner.id!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  (!controller.load.value ||
                                      controller.bannerProducts.length > 0)) {
                                List<Product> products = snapshot.data!;

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

                                return Column(
                                  children: row.toList(),
                                );
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              return loading();
                            },
                          )),
                      if (controller.load.value)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: loading(),
                        )
                    ],
                  )),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      );
    });
  }
}
