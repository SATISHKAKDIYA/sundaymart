import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/controllers/category_controller.dart';
import 'package:githubit/src/models/category.dart';

class CategoryItem extends GetView<CategoryController> {
  final String? imageUrl;
  final int? id;
  final String? name;

  const CategoryItem({this.id, this.imageUrl, this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 15),
        width: 80,
        child: InkWell(
          onTap: () {
            controller.inActiveCategory.value = controller.activeCategory.value;
            controller.activeCategory.value =
                Category(id: id, imageUrl: imageUrl, name: name);
            controller.productController.clearFilter();
            controller.load.value = true;
            controller.categoryProductList[id!] = [];
            Get.toNamed("/subCategoryProducts");
          },
          child: Column(
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Color.fromRGBO(0, 0, 0, 1)
                      : Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    width: 80,
                    height: 80,
                    fit: BoxFit.fill,
                    imageUrl: "$GLOBAL_IMAGE_URL$imageUrl",
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      child: Icon(
                        const IconData(0xee4b, fontFamily: 'MIcon'),
                        color: Color.fromRGBO(233, 233, 230, 1),
                        size: 40.sp,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Text(
                "$name",
                maxLines: 2,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    letterSpacing: -0.58,
                    color: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1)),
              ),
            ],
          ),
        ));
  }
}
