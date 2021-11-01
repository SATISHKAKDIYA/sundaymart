import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/filter_brand_button.dart';
import 'package:githubit/src/controllers/product_controller.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class Filter extends GetView<ProductController> {
  final Function()? onPress;
  final bool? isBrandShow;

  Filter({this.onPress, this.isBrandShow = true});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: 1.sw,
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 30),
          decoration: BoxDecoration(
              color:
                  Get.isDarkMode ? Color.fromRGBO(37, 48, 63, 1) : Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Get.isDarkMode
                        ? Color.fromRGBO(0, 0, 0, 0.25)
                        : Color.fromRGBO(169, 169, 169, 0.25),
                    offset: Offset(0, -8),
                    blurRadius: 70,
                    spreadRadius: 0)
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Color.fromRGBO(26, 34, 44, 1)
                        : Color.fromRGBO(249, 249, 246, 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Sort by price".tr,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            letterSpacing: -0.4,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(130, 139, 150, 1)
                                : Color.fromRGBO(136, 136, 126, 1)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    Container(
                      child: Text(
                        "${controller.rangeStartPrice.value} - ${controller.rangeEndPrice.value}",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            letterSpacing: -0.3,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(20, 20, 20, 1)),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    Container(
                        width: 1.sw,
                        height: 32,
                        child: SfRangeSliderTheme(
                          data: SfRangeSliderThemeData(
                              activeTrackColor: Color.fromRGBO(255, 184, 0, 1),
                              activeTrackHeight: 8,
                              inactiveTrackHeight: 8,
                              inactiveTrackColor:
                                  Color.fromRGBO(235, 235, 233, 1),
                              thumbRadius: 16,
                              thumbColor: Color.fromRGBO(255, 255, 255, 1)),
                          child: SfRangeSlider(
                            min: 0.0,
                            max: 10000.0,
                            values: SfRangeValues(
                                controller.rangeStartPrice.value,
                                controller.rangeEndPrice.value),
                            endThumbIcon: Icon(
                              const IconData(0xefd8, fontFamily: 'MIcon'),
                              color: Color.fromRGBO(255, 184, 0, 1),
                              size: 20.sp,
                            ),
                            startThumbIcon: Icon(
                              const IconData(0xefd8, fontFamily: 'MIcon'),
                              color: Color.fromRGBO(255, 184, 0, 1),
                              size: 20.sp,
                            ),
                            showTicks: false,
                            showLabels: false,
                            enableTooltip: false,
                            interval: 10000,
                            onChanged: (SfRangeValues values) {
                              int start = 0;
                              int end = 0;
                              if (values.start is double) {
                                double startP = values.start;
                                start = startP.toInt();
                              } else
                                start = values.start;

                              if (values.end is double) {
                                double endP = values.end;
                                end = endP.toInt();
                              } else
                                end = values.end;

                              controller.rangeStartPrice.value = start;
                              controller.rangeEndPrice.value = end;
                            },
                          ),
                        )),
                    Container(
                      height: 50,
                      width: 1.sw - 70,
                      margin: EdgeInsets.only(top: 35, left: 20, right: 20),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Get.isDarkMode
                              ? Color.fromRGBO(37, 48, 63, 1)
                              : Color.fromRGBO(233, 233, 230, 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            child: Container(
                              width: 0.5.sw - 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    if (controller.sortType.value == 0)
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(69, 165, 36, 0.13),
                                          offset: Offset(0, 2),
                                          spreadRadius: 0,
                                          blurRadius: 2)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: controller.sortType.value == 0
                                      ? Color.fromRGBO(69, 165, 36, 1)
                                      : Colors.transparent),
                              child: Text(
                                "Sort by low price".tr,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    letterSpacing: -0.4,
                                    color: controller.sortType.value == 0
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(136, 136, 126, 1)),
                              ),
                            ),
                            onTap: () {
                              controller.sortType.value = 0;
                            },
                          ),
                          InkWell(
                            child: Container(
                              width: 0.5.sw - 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    if (controller.sortType.value == 1)
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(69, 165, 36, 0.13),
                                          offset: Offset(0, 2),
                                          spreadRadius: 0,
                                          blurRadius: 2)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: controller.sortType.value == 1
                                      ? Color.fromRGBO(69, 165, 36, 1)
                                      : Colors.transparent),
                              child: Text(
                                "Sort by high price".tr,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    letterSpacing: -0.4,
                                    color: controller.sortType.value == 1
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Get.isDarkMode
                                            ? Color.fromRGBO(130, 139, 150, 1)
                                            : Color.fromRGBO(136, 136, 126, 1)),
                              ),
                            ),
                            onTap: () {
                              controller.sortType.value = 1;
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (isBrandShow!)
                Container(
                  decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Color.fromRGBO(26, 34, 44, 1)
                          : Color.fromRGBO(249, 249, 246, 1),
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  width: 1.sw - 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "Brands".tr,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            letterSpacing: -0.4,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(130, 139, 150, 1)
                                : Color.fromRGBO(136, 136, 126, 1)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Wrap(
                          alignment: WrapAlignment.start,
                          direction: Axis.horizontal,
                          verticalDirection: VerticalDirection.down,
                          runAlignment: WrapAlignment.start,
                          spacing: 10,
                          runSpacing: 10,
                          children: controller.allBrands().map((item) {
                            return FilterBrandButton(
                              isActive: controller.inFilterBrands(item.id!),
                              name: item.name,
                              id: item.id,
                              onTap: () {
                                controller.setFilterBrands(item.id!);
                              },
                            );
                          }).toList())
                    ],
                  ),
                ),
              TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.all(0))),
                  child: Container(
                    width: 1.sw - 30,
                    height: 60,
                    alignment: Alignment.center,
                    child: Text(
                      "Confirm filter".tr,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp,
                          color: Color.fromRGBO(255, 255, 255, 1)),
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(69, 165, 36, 1),
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: onPress),
            ],
          ),
        ));
  }
}
