import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/controllers/product_controller.dart';

class ExtrasWithSelect extends GetView<ProductController> {
  final List? extras;
  final int? groupId;

  ExtrasWithSelect({this.extras, this.groupId});

  @override
  Widget build(BuildContext context) {
    print(extras);
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
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              "$GLOBAL_IMAGE_URL${item['image_url']}")),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          width: 1,
                          color: hasExtra
                              ? Color.fromRGBO(69, 165, 36, 1)
                              : Color.fromRGBO(233, 233, 230, 1))),
                  alignment: Alignment.center,
                ));
          }).toList(),
        ),
      );
    });
  }
}
