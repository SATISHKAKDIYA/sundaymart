import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/controllers/product_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExtrasWithImage extends GetView<ProductController> {
  final List? extras;
  final int? groupId;

  ExtrasWithImage({this.extras, this.groupId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        child: Row(
          children: extras!.map((item) {
            bool hasExtra = controller.activeProduct.value.extras != null &&
                controller.activeProduct.value.extras!
                        .indexWhere((element) => element.id == item['id']) !=
                    -1;
            return InkWell(
                onTap: () => controller.addToExtras(
                    item['id'],
                    item['language']['name'],
                    groupId!,
                    double.parse(item['price'].toString())),
                child: Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: hasExtra
                                ? Color.fromRGBO(69, 165, 36, 1)
                                : Color.fromRGBO(233, 233, 230, 1))),
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                        imageUrl: "$GLOBAL_IMAGE_URL${item['image_url']}",
                        placeholder: (context, url) => Container(
                          width: 30,
                          height: 100,
                          alignment: Alignment.center,
                          child: Icon(
                            const IconData(0xee4b, fontFamily: 'MIcon'),
                            color: Color.fromRGBO(233, 233, 230, 1),
                            size: 20.sp,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    )));
          }).toList(),
        ),
      );
    });
  }
}
