import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/comment_dialog.dart';
import 'package:githubit/src/components/comment_item.dart';
import 'package:githubit/src/components/extras_button.dart';
import 'package:githubit/src/components/extras_color.dart';
import 'package:githubit/src/components/extras_image.dart';
import 'package:githubit/src/components/extras_with_select.dart';
import 'package:githubit/src/components/home_category_products.dart';
import 'package:githubit/src/controllers/product_controller.dart';
import 'package:githubit/src/models/product.dart';

class ProductDetail extends GetView<ProductController> {
  Widget _dot(index, int selectedIndex) {
    return Container(
      width: 40,
      height: 4,
      margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: controller.selectedIndex.value == index
              ? Color.fromRGBO(69, 165, 36, 1)
              : Color.fromRGBO(233, 233, 230, 1)),
    );
  }

  Widget _indicator(images, int selectedIndex) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 40),
      width: 136,
      height: 4,
      alignment: Alignment.center,
      child: ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: images.length,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return _dot(index, selectedIndex);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Product? product = controller.activeProduct.value;
      int count = controller.cartController.getProductCountById(product.id!);
      var statusBarHeight = MediaQuery.of(context).padding.top;
      var appBarHeight = AppBar().preferredSize.height;

      return Scaffold(
        backgroundColor: Color.fromRGBO(249, 249, 246, 1),
        appBar: PreferredSize(
            preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
            child: AppBarCustom(
                title: "Details".tr,
                hasBack: true,
                actions: Obx(
                  () => InkWell(
                    onTap: () => controller.addToLiked(product),
                    child: Icon(
                      controller.isLiked(product.id!)
                          ? const IconData(0xee0e, fontFamily: "MIcon")
                          : const IconData(0xee0f, fontFamily: "MIcon"),
                      color: controller.isLiked(product.id!)
                          ? Color.fromRGBO(222, 31, 54, 1)
                          : Color.fromRGBO(0, 0, 0, 1),
                      size: 24.sp,
                    ),
                  ),
                ))),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Color.fromRGBO(19, 20, 21, 1)
                        : Color.fromRGBO(255, 255, 255, 0.8),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 2,
                          spreadRadius: 0,
                          color: Color.fromRGBO(169, 169, 150, 0.13))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 250,
                      width: 1.sw,
                      child: PageView.builder(
                          itemCount: product.images!.length,
                          onPageChanged: (index) {
                            controller.selectedIndex.value = index;
                          },
                          itemBuilder: (context, index) {
                            String image = product.images![index]["image_url"];
                            return CachedNetworkImage(
                              width: 250,
                              fit: BoxFit.contain,
                              imageUrl: "$GLOBAL_IMAGE_URL$image",
                              placeholder: (context, url) => Container(
                                width: 250,
                                alignment: Alignment.center,
                                child: Icon(
                                  const IconData(0xee4b, fontFamily: 'MIcon'),
                                  color: Color.fromRGBO(233, 233, 230, 1),
                                  size: 40.sp,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            );
                          }),
                    ),
                    _indicator(product.images!, controller.selectedIndex.value),
                    Container(
                      width: 1.sw - 30,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "${product.name}",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                            height: 1.5,
                            letterSpacing: -0.4,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(0, 0, 0, 1)),
                      ),
                    ),
                    Divider(
                      color: Get.isDarkMode
                          ? Color.fromRGBO(255, 255, 255, 0.04)
                          : Color.fromRGBO(0, 0, 0, 0.04),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: <Widget>[
                            Text(
                                "${controller.getDiscountPrice(product.discount!, product.price!, product.discountType!)}",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    height: 1.4,
                                    letterSpacing: -0.4,
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1))),
                            if (product.discount! > 0)
                              Container(
                                width: 4,
                                height: 4,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(136, 136, 126, 0.28)),
                              ),
                            if (product.discount! > 0)
                              Text("${product.price}",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.sp,
                                      decoration: TextDecoration.lineThrough,
                                      letterSpacing: -0.4,
                                      color: Get.isDarkMode
                                          ? Color.fromRGBO(255, 255, 255, 1)
                                          : Color.fromRGBO(0, 0, 0, 1))),
                          ],
                        ),
                        if (product.discount! > 0)
                          Container(
                              height: 30,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color.fromRGBO(222, 31, 54, 1)),
                              child: Row(
                                children: <Widget>[
                                  RichText(
                                      text: TextSpan(
                                          text: "Sale".tr,
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12.sp,
                                              letterSpacing: -0.4,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 1)),
                                          children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                " ${controller.getDiscount(product.discount!, product.discountType!)} — ${controller.getDiscountAmount(product.discount!, product.price!, product.discountType!)}",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp,
                                                letterSpacing: -0.4,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1))),
                                        TextSpan(
                                            text: " ${"off".tr}",
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp,
                                                letterSpacing: -0.4,
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 1)))
                                      ]))
                                ],
                              ))
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    )
                  ],
                ),
              ),
              Container(
                width: 1.sw,
                height: 64,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Color.fromRGBO(26, 34, 44, 1)
                        : Color.fromRGBO(249, 249, 246, 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Icon(
                                const IconData(0xf18e, fontFamily: 'MIcon'),
                                size: 20.sp,
                                color: Color.fromRGBO(255, 161, 0, 1),
                              ),
                              Text(
                                "${product.rating!.toStringAsFixed(1)}",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                    letterSpacing: -0.35,
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 22,
                          height: 1,
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(231, 231, 231, 1)
                                  : Color.fromRGBO(231, 231, 231, 1)),
                        ),
                        Icon(
                          const IconData(0xef43, fontFamily: 'MIcon'),
                          color: Color.fromRGBO(69, 165, 36, 1),
                          size: 20.sp,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${product.reviewCount!} ${"reviews".tr}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              letterSpacing: -0.35,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ],
                    ),
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
                                      ? Color.fromRGBO(37, 48, 63, 1)
                                      : Color.fromRGBO(233, 233, 230, 1),
                                  borderRadius: BorderRadius.circular(18)),
                              child: Icon(
                                const IconData(0xf1af, fontFamily: 'MIcon'),
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Colors.black,
                                size: 20.sp,
                              ),
                            ),
                            onTap: () {
                              controller.cartController.decrement(product.id);
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
                            onTap: () {
                              if (count == 0)
                                controller.cartController.addToCart(product);
                              else
                                controller.cartController.increment(product.id);
                            },
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
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Colors.black,
                                size: 20.sp,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 1.sw,
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Color.fromRGBO(19, 20, 21, 1)
                        : Color.fromRGBO(243, 243, 240, 1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text("${"Availabity".tr} — ",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                letterSpacing: -0.4,
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(0, 0, 0, 1))),
                        Text("${"In stock".tr} (${product.amount!})",
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                letterSpacing: -0.4,
                                color: Color.fromRGBO(53, 105, 184, 1))),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<Map<String, dynamic>>(
                      future: controller.getExtras(product.id!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Map<String, dynamic> data = snapshot.data!;
                          List description = data['description'];
                          List extras = data['extras'];
                          List comments = data['comments'];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  width: 1.sw - 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Get.isDarkMode
                                          ? Color.fromRGBO(26, 34, 44, 1)
                                          : Color.fromRGBO(249, 249, 246, 1)),
                                  child: Column(
                                    children: extras.map((item) {
                                      int index = extras.indexWhere(
                                          (element) => element == item);

                                      return Container(
                                        width: 1.sw - 30,
                                        decoration: BoxDecoration(
                                            border: index != extras.length - 1
                                                ? Border(
                                                    bottom: BorderSide(
                                                        color: Color.fromRGBO(
                                                            0, 0, 0, 0.04),
                                                        width: 1))
                                                : Border()),
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "${item['language']['name']}",
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20.sp,
                                                  height: 1.2,
                                                  letterSpacing: -1,
                                                  color: Get.isDarkMode
                                                      ? Color.fromRGBO(
                                                          255, 255, 255, 1)
                                                      : Color.fromRGBO(
                                                          0, 0, 0, 1)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            if (int.parse(item['type']
                                                        .toString()) ==
                                                    1 &&
                                                item['extras'].length > 0)
                                              ExtrasWithImage(
                                                extras: item['extras'],
                                                groupId: item['id'],
                                              ),
                                            if (int.parse(item['type']
                                                        .toString()) ==
                                                    2 &&
                                                item['extras'].length > 0)
                                              ExtrasWithColor(
                                                extras: item['extras'],
                                                groupId: item['id'],
                                              ),
                                            if (int.parse(item['type']
                                                        .toString()) ==
                                                    3 &&
                                                item['extras'].length > 0)
                                              ExtrasWithButton(
                                                extras: item['extras'],
                                                groupId: item['id'],
                                              ),
                                            if (int.parse(item['type']
                                                        .toString()) ==
                                                    4 &&
                                                item['extras'].length > 0)
                                              ExtrasWithSelect(
                                                extras: item['extras'],
                                                groupId: item['id'],
                                              ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Description".tr,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20.sp,
                                    height: 1.2,
                                    letterSpacing: -1,
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1)),
                              ),
                              Column(
                                children: description.map((item) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: 1.sw - 30,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: Get.isDarkMode
                                                    ? Color.fromRGBO(
                                                        255, 255, 255, 0.04)
                                                    : Color.fromRGBO(
                                                        0, 0, 0, 0.04)))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: 0.6.sw - 40,
                                          child: Text(
                                            "${item['language']['key']}",
                                            softWrap: true,
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                                letterSpacing: -0.4,
                                                color: Get.isDarkMode
                                                    ? Color.fromRGBO(
                                                        255, 255, 255, 1)
                                                    : Color.fromRGBO(
                                                        0, 0, 0, 1)),
                                          ),
                                        ),
                                        Container(
                                          width: 0.4.sw,
                                          child: Text(
                                            "${item['language']['value']}",
                                            softWrap: true,
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14.sp,
                                                letterSpacing: -0.4,
                                                color: Get.isDarkMode
                                                    ? Color.fromRGBO(
                                                        255, 255, 255, 1)
                                                    : Color.fromRGBO(
                                                        0, 0, 0, 1)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Reviews".tr,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.sp,
                                        height: 1.2,
                                        letterSpacing: -1,
                                        color: Get.isDarkMode
                                            ? Color.fromRGBO(255, 255, 255, 1)
                                            : Color.fromRGBO(0, 0, 0, 1)),
                                  ),
                                  Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(28)),
                                    child: TextButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                    EdgeInsetsGeometry>(
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 12)),
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(Color.fromRGBO(
                                                        69, 165, 36, 1)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(28.0),
                                            ))),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    backgroundColor: Get
                                                            .isDarkMode
                                                        ? Color.fromRGBO(
                                                            26, 34, 44, 1)
                                                        : Color.fromRGBO(
                                                            255, 255, 255, 1),
                                                    content: CommentDialog());
                                              });
                                        },
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(right: 5),
                                              child: Icon(
                                                const IconData(0xef43,
                                                    fontFamily: 'MIcon'),
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                            Text(
                                              "Add comment".tr,
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1)),
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                children: comments.map((item) {
                                  int index = comments
                                      .indexWhere((element) => element == item);
                                  DateTime date =
                                      DateTime.parse(item['created_at']);

                                  return CommentItem(
                                    isLast: index == (comments.length - 1),
                                    rating:
                                        double.parse(item['star'].toString()),
                                    date:
                                        "${date.day}.${date.month}.${date.year} | ${date.hour}:${date.minute}",
                                    comment: item['comment_text'],
                                    author:
                                        "${item['user']['name']} ${item['user']['surname']}",
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              HomeCategoryProducts(
                                name: "Related products".tr,
                                id: int.parse(data['id_category'].toString()),
                                isSimilar: true,
                              ),
                              SizedBox(
                                height: 120,
                              )
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }

                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        extendBody: true,
        bottomNavigationBar: Container(
            height: 110,
            width: 1.sw,
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Color.fromRGBO(37, 48, 63, 0.7)
                    : Color.fromRGBO(255, 255, 255, 0.7)),
            alignment: Alignment.topCenter,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  height: 110,
                  width: 1.sw,
                  padding:
                      EdgeInsets.only(top: 27, bottom: 20, left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${controller.cartController.cartProducts.length} ${"product price".tr}",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  letterSpacing: -0.4,
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(130, 139, 150, 1)
                                      : Color.fromRGBO(136, 136, 126, 1)),
                            ),
                            Text(
                              "${(controller.cartController.calculateAmount() - controller.cartController.calculateDiscount()).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28.sp,
                                  height: 1.3,
                                  letterSpacing: -0.4,
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1)),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        child: Container(
                          height: 60,
                          width: 60,
                          child: Icon(
                            const IconData(0xf115, fontFamily: 'MIcon'),
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromRGBO(0, 0, 0, 1)),
                        ),
                        onTap: () => Get.toNamed("/cart"),
                      ),
                      controller.cartController.calculateAmount() > 0
                          ? InkWell(
                              child: Container(
                                height: 60,
                                width: 0.42.sw,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(69, 165, 36, 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  "Buy now".tr,
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.sp,
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ),
                              onTap: () => Get.toNamed("/checkout"),
                            )
                          : Container(
                              width: 0.42.sw,
                            )
                    ],
                  ),
                ),
              ),
            )),
      );
    });
  }
}
