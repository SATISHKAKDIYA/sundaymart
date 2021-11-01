import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/controllers/category_controller.dart';
import 'package:githubit/src/models/category.dart';

class MainCategoryItem extends GetView<CategoryController> {
  final Category? category;
  final bool? isLast;

  MainCategoryItem({this.category, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: (1.sw - 50) / 3,
        margin: EdgeInsets.only(right: isLast! ? 0 : 10, bottom: 10),
        child: InkWell(
          onTap: () {
            controller.activeCategory.value = category!;
            controller.productController.clearFilter();
            controller.load.value = true;
            controller.categoryProductList[category!.id!] = [];
            Get.toNamed("/categoryProducts");
          },
          child: Column(
            children: <Widget>[
              Container(
                width: (1.sw - 50) / 3,
                height: (1.sw - 50) / 3,
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      width: (1.sw - 50) / 3,
                      height: (1.sw - 50) / 3,
                      fit: BoxFit.contain,
                      imageUrl: "$GLOBAL_IMAGE_URL${category!.imageUrl}",
                      placeholder: (context, url) => Container(
                        width: (1.sw - 50) / 3,
                        height: (1.sw - 50) / 3,
                        alignment: Alignment.center,
                        child: Icon(
                          const IconData(0xee4b, fontFamily: 'MIcon'),
                          color: Color.fromRGBO(233, 233, 230, 1),
                          size: 40.sp,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )),
              ),
              Text(
                "${category!.name}",
                maxLines: 2,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    letterSpacing: -0.58,
                    color: Color.fromRGBO(0, 0, 0, 1)),
              ),
            ],
          ),
        ));
  }
}
