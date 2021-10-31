import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/controllers/product_controller.dart';
import 'package:githubit/src/models/product.dart';

class CartItem extends GetView<ProductController> {
  final Product? product;

  CartItem({this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw - 30,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
      decoration: BoxDecoration(
          color: Get.isDarkMode ? Color.fromRGBO(37, 48, 63, 1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
                color: Get.isDarkMode
                    ? Color.fromRGBO(23, 27, 32, 0.13)
                    : Color.fromRGBO(169, 169, 150, 0.13))
          ]),
      child: Row(
        children: <Widget>[
          Container(
            width: 0.25.sw,
            margin: EdgeInsets.only(right: 10),
            child: CachedNetworkImage(
              width: 0.25.sw,
              fit: BoxFit.contain,
              imageUrl: "$GLOBAL_IMAGE_URL${product!.image}",
              placeholder: (context, url) => Container(
                width: 0.25.sw,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 0.75.sw - 70,
                child: Text(
                  "${product!.name}",
                  softWrap: true,
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      letterSpacing: -0.4,
                      height: 1.4,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(255, 255, 255, 1)
                          : Color.fromRGBO(0, 0, 0, 1)),
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                      "${controller.getDiscountPrice(product!.discount!, product!.price!, product!.discountType!)}",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 16.sp,
                          letterSpacing: -0.4,
                          height: 1.75,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1))),
                  SizedBox(
                    width: 10,
                  ),
                  if (product!.discount! > 0)
                    Text("${product!.price}",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            decoration: TextDecoration.lineThrough,
                            letterSpacing: -0.4,
                            height: 1.7,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(0, 0, 0, 1))),
                  if (product!.discount! > 0)
                    Container(
                      width: 4,
                      height: 4,
                      margin: EdgeInsets.only(left: 8, right: 8, top: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Color.fromRGBO(136, 136, 126, 0.28)),
                    ),
                  if (product!.discount! > 0)
                    Text(
                        controller.getDiscount(
                            product!.discount!, product!.discountType!),
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 1.7,
                            fontSize: 12.sp,
                            letterSpacing: -0.4,
                            color: Color.fromRGBO(221, 35, 57, 1))),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Obx(() {
                int count =
                    controller.cartController.getProductCountById(product!.id!);

                return Container(
                  width: 0.75.sw - 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 103,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(26, 34, 44, 1)
                                        : Color.fromRGBO(233, 233, 230, 1),
                                    borderRadius: BorderRadius.circular(18)),
                                child: Icon(
                                  const IconData(0xf1af, fontFamily: 'MIcon'),
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1),
                                  size: 20.sp,
                                ),
                              ),
                              onTap: () {
                                controller.cartController
                                    .decrement(product!.id);
                              },
                            ),
                            Text("$count",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    height: 1.4,
                                    fontSize: 20.sp,
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
                                        ? Color.fromRGBO(26, 34, 44, 1)
                                        : Color.fromRGBO(233, 233, 230, 1),
                                    borderRadius: BorderRadius.circular(18)),
                                child: Icon(
                                  const IconData(0xea13, fontFamily: 'MIcon'),
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1),
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
                      ),
                      InkWell(
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(26, 34, 44, 1)
                                  : Color.fromRGBO(233, 233, 230, 1),
                              borderRadius: BorderRadius.circular(18)),
                          child: Icon(
                            const IconData(0xec29, fontFamily: 'MIcon'),
                            color: Get.isDarkMode
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(136, 136, 126, 1),
                            size: 20.sp,
                          ),
                        ),
                        onTap: () {
                          controller.cartController
                              .removeProductFromCart(product!.id!);
                        },
                      )
                    ],
                  ),
                );
              })
            ],
          )
        ],
      ),
    );
  }
}
