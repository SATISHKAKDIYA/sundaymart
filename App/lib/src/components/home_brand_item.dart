import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:githubit/src/controllers/brands_controller.dart';
import 'package:githubit/src/models/brand.dart';

class HomeBrandItem extends GetView<BrandsController> {
  final int? id;
  final String? name;
  final String? imageUrl;

  HomeBrandItem({this.id, this.imageUrl, this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 120,
        height: 120,
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            color: Get.isDarkMode ? Color.fromRGBO(0, 0, 0, 1) : Colors.white,
            borderRadius: BorderRadius.circular(60)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: CachedNetworkImage(
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            imageUrl: "$GLOBAL_IMAGE_URL$imageUrl",
            placeholder: (context, url) => Container(
              width: 120,
              height: 120,
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
