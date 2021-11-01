import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/controllers/product_controller.dart';

class ExtrasWithButton extends GetView<ProductController> {
  final List? extras;
  final int? groupId;

  ExtrasWithButton({this.extras, this.groupId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        child: Wrap(
          alignment: WrapAlignment.start,
          direction: Axis.horizontal,
          verticalDirection: VerticalDirection.down,
          runAlignment: WrapAlignment.start,
          runSpacing: 10,
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
                child: IntrinsicWidth(
                  child: Container(
                      height: 30,
                      constraints: BoxConstraints(minWidth: 30),
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: hasExtra
                              ? Color.fromRGBO(69, 165, 36, 1)
                              : Get.isDarkMode
                                  ? Color.fromRGBO(26, 34, 44, 1)
                                  : Color.fromRGBO(255, 255, 255, 1),
                          border: Border.all(
                              width: 1,
                              color: hasExtra
                                  ? Color.fromRGBO(69, 165, 36, 1)
                                  : Color.fromRGBO(233, 233, 230, 1))),
                      alignment: Alignment.center,
                      child: Text(
                        "${item['language']['name']}",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.4,
                            color: hasExtra
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Get.isDarkMode
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 14.sp),
                      )),
                ));
          }).toList(),
        ),
      );
    });
  }
}
