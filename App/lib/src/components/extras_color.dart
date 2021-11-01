import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:githubit/src/controllers/product_controller.dart';
import 'package:githubit/src/utils/hex_color.dart';

class ExtrasWithColor extends GetView<ProductController> {
  final List? extras;
  final int? groupId;

  ExtrasWithColor({this.extras, this.groupId});

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
                width: 20,
                height: 20,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: hasExtra ? 2 : 1,
                        color: hasExtra
                            ? HexColor(item['background_color'])
                            : Color.fromRGBO(233, 233, 230, 1))),
                alignment: Alignment.center,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: HexColor(item['background_color'])),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
