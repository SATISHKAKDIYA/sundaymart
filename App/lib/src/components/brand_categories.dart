import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/brand_categories_item.dart';
import 'package:githubit/src/components/shadows/brand_categories_item_shadow.dart';
import 'package:githubit/src/controllers/brands_controller.dart';
import 'package:githubit/src/models/brand.dart';

class BrandCategories extends GetView<BrandsController> {
  final String? name;
  final int? id;

  BrandCategories({this.name, this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Obx(() {
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
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
                      controller.getHasLimit(id) ? "View all".tr : "Less".tr,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          letterSpacing: -0.5,
                          color: Color.fromRGBO(53, 105, 184, 1)),
                    ),
                    onTap: () {
                      controller.setHasLimit(id);
                    },
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Brand>>(
              future: controller.getBrandsList(id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Brand> brands = snapshot.data!;

                  List<Widget> brandWidgetList = [];
                  List<Widget> brandSubWidgetList = [];

                  for (int i = 0; i < brands.length; i++) {
                    brandSubWidgetList.add(BrandCategoriesItem(
                      isLast: (i + 1) % 3 == 0,
                      imageUrl: brands[i].imageUrl,
                      id: brands[i].id,
                      name: brands[i].name,
                    ));

                    if ((i + 1) % 3 == 0 || i == (brands.length - 1)) {
                      brandWidgetList.add(Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: brandSubWidgetList.toList()));
                      brandSubWidgetList = [];
                    }
                  }

                  return Container(
                      margin: EdgeInsets.only(top: 18, left: 15, right: 15),
                      width: 1.sw,
                      child: Column(
                        children: brandWidgetList.toList(),
                      ));
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return Container(
                    margin: EdgeInsets.only(top: 18, left: 15, right: 15),
                    width: 1.sw,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        BrandCategoriesItemShadow(),
                        BrandCategoriesItemShadow(),
                        BrandCategoriesItemShadow(
                          isLast: true,
                        ),
                      ],
                    ));
              },
            )
          ],
        );
      }),
    );
  }
}
