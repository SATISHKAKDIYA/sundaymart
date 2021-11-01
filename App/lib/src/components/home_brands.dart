import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/home_brand_item.dart';
import 'package:githubit/src/components/shadows/home_brand_item_shadow.dart';
import 'package:githubit/src/controllers/brands_controller.dart';
import 'package:githubit/src/models/brand.dart';

class HomeBrands extends GetView<BrandsController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Brands".tr,
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
                  onTap: () => Get.toNamed("/brands"),
                ),
              ],
            ),
          ),
          Container(
              height: 120,
              margin: EdgeInsets.only(top: 18),
              width: 1.sw,
              child: FutureBuilder<List<Brand>>(
                future: controller.getBrands(-1, 10, 0),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Brand> brands = snapshot.data ?? [];

                    return ListView.builder(
                        itemCount: brands.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        itemBuilder: (context, index) {
                          Brand brand = brands[index];

                          return HomeBrandItem(
                            id: brand.id,
                            name: brand.name,
                            imageUrl: brand.imageUrl,
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      itemBuilder: (context, index) {
                        return HomeBrandItemShadow();
                      });
                },
              ))
        ],
      ),
    );
  }
}
