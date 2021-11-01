import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/controllers/brands_controller.dart';
import 'package:githubit/src/models/brand.dart';

class BrandCategoriesItem extends GetView<BrandsController> {
  final bool? isLast;
  final int? id;
  final String? imageUrl;
  final String? name;

  BrandCategoriesItem({this.isLast = false, this.imageUrl, this.id, this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: (1.sw - 50) / 3,
        height: (1.sw - 50) / 3,
        margin: EdgeInsets.only(right: isLast! ? 0 : 10, bottom: 10),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("$GLOBAL_IMAGE_URL$imageUrl"),
                fit: BoxFit.cover),
            color: Get.isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10)),
      ),
      onTap: () {
        controller.activeBrand.value =
            Brand(id: id, name: name, imageUrl: imageUrl);
        controller.load.value = true;
        controller.brandProductsList[id!] = [];
        Get.toNamed("/brandProducts");
      },
    );
  }
}
