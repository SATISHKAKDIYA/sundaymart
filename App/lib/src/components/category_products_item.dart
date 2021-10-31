import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/count_down_time.dart';
import 'package:githubit/src/controllers/product_controller.dart';
import 'package:githubit/src/models/product.dart';

class CategoryProductItem extends GetView<ProductController> {
  final Product? product;

  CategoryProductItem({this.product});

  @override
  Widget build(BuildContext context) {
    int now = DateTime.now().toUtc().millisecondsSinceEpoch;
    bool timerStarted = product!.startTime! <= now && product!.endTime! >= now;

    return Container(
      width: (1.sw - 38) / 2,
      height: product!.isCountDown == 1 && timerStarted ? 332 : 283,
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Get.isDarkMode
              ? Color.fromRGBO(26, 34, 44, 1)
              : Color.fromRGBO(251, 251, 248, 1)),
      child: Column(
        children: <Widget>[
          InkWell(
            child: Container(
              width: (1.sw - 38) / 2,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              height: 223,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Get.isDarkMode
                      ? Color.fromRGBO(37, 48, 63, 1)
                      : Colors.white),
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: (1.sw - 68) / 2,
                        height: 100,
                        child: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                              width: (1.sw - 68) / 2,
                              height: 100,
                              fit: BoxFit.contain,
                              imageUrl: "$GLOBAL_IMAGE_URL${product!.image}",
                              placeholder: (context, url) => Container(
                                width: (1.sw - 68) / 2,
                                height: 100,
                                alignment: Alignment.center,
                                child: Icon(
                                  const IconData(0xee4b, fontFamily: 'MIcon'),
                                  color: Color.fromRGBO(233, 233, 230, 1),
                                  size: 40.sp,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            Positioned(
                                right: 0,
                                top: 4,
                                child: Obx(() {
                                  return InkWell(
                                    onTap: () =>
                                        controller.addToLiked(product!),
                                    child: Icon(
                                      controller.isLiked(product!.id!)
                                          ? const IconData(0xee0e,
                                              fontFamily: "MIcon")
                                          : const IconData(0xee0f,
                                              fontFamily: "MIcon"),
                                      color: controller.isLiked(product!.id!)
                                          ? Color.fromRGBO(222, 31, 54, 1)
                                          : Get.isDarkMode
                                              ? Color.fromRGBO(255, 255, 255, 1)
                                              : Color.fromRGBO(0, 0, 0, 1),
                                      size: 28.sp,
                                    ),
                                  );
                                }))
                          ],
                        ),
                      ),
                      Text(
                        "${product!.name}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            letterSpacing: -0.4,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(0, 0, 0, 1)),
                      ),
                      Container(
                        width: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Icon(
                              const IconData(0xf18e, fontFamily: 'MIcon'),
                              size: 16.sp,
                              color: Color.fromRGBO(255, 161, 0, 1),
                            ),
                            Text(
                              "${product!.rating!.toStringAsFixed(1)}",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  letterSpacing: -0.35,
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1)),
                            ),
                          ],
                        ),
                      ),
                      if (product!.discount! > 0)
                        Row(
                          children: <Widget>[
                            Text("${product!.price}",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    decoration: TextDecoration.lineThrough,
                                    letterSpacing: -0.4,
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1))),
                            Container(
                              width: 4,
                              height: 4,
                              margin: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Color.fromRGBO(136, 136, 126, 0.28)),
                            ),
                            Text(
                                "${"Sale".tr} -${controller.getDiscount(product!.discount!, product!.discountType!)}",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.sp,
                                    letterSpacing: -0.4,
                                    color: Color.fromRGBO(221, 35, 57, 1))),
                          ],
                        )
                    ],
                  )
                ],
              ),
            ),
            onTap: () {
              controller.activeProduct.value = product!;
              Get.toNamed("productDetail");
            },
          ),
          Container(
              height: product!.isCountDown == 1 && timerStarted ? 109 : 60,
              width: (1.sw - 38) / 2,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (product!.isCountDown == 1 && timerStarted)
                    CountDownTimer(
                      width: (1.sw - 68) / 2,
                      startTime: product!.startTime!,
                      endTime: product!.endTime!,
                    ),
                  Obx(() {
                    int count = controller.cartController
                        .getProductCountById(product!.id!);

                    return Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          if (count == 0)
                            Text(
                                "${controller.getDiscountPrice(product!.discount!, product!.price!, product!.discountType!)}",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    letterSpacing: -0.4,
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1))),
                          if (count > 0)
                            InkWell(
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(37, 48, 63, 1)
                                        : Color.fromRGBO(233, 233, 230, 1),
                                    borderRadius: BorderRadius.circular(18)),
                                child: Icon(
                                  const IconData(0xf1af, fontFamily: 'MIcon'),
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(255, 244, 255, 1)
                                      : Colors.black,
                                  size: 20.sp,
                                ),
                              ),
                              onTap: () {
                                controller.cartController
                                    .decrement(product!.id);
                              },
                            ),
                          if (count > 0)
                            Text("$count",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    letterSpacing: -0.4,
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1))),
                          InkWell(
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(37, 48, 63, 1)
                                      : Color.fromRGBO(233, 233, 230, 1),
                                  borderRadius: BorderRadius.circular(18)),
                              child: Icon(
                                const IconData(0xea13, fontFamily: 'MIcon'),
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(255, 244, 255, 1)
                                    : Colors.black,
                                size: 20.sp,
                              ),
                            ),
                            onTap: () {
                              if (count == 0)
                                controller.cartController.addToCart(product!);
                              else
                                controller.cartController
                                    .increment(product!.id);
                            },
                          )
                        ],
                      ),
                    );
                  })
                ],
              ))
        ],
      ),
    );
  }
}
