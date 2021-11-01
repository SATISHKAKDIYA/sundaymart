import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/add_card.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/card_item.dart';
import 'package:githubit/src/components/cart_summary_item.dart';
import 'package:githubit/src/components/checkout_bottom_button.dart';
import 'package:githubit/src/components/checkout_button.dart';
import 'package:githubit/src/components/checkout_dot.dart';
import 'package:githubit/src/components/checkout_head.dart';
import 'package:githubit/src/components/checkout_textfield.dart';
import 'package:githubit/src/controllers/cart_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:githubit/src/models/address.dart';
import 'package:githubit/src/models/user.dart';

class Checkout extends GetView<CartController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Address address =
          controller.shopController.addressController.getDefaultAddress();
      User? user = controller.shopController.authController.user.value;
      controller.checkoutData();
      var statusBarHeight = MediaQuery.of(context).padding.top;
      var appBarHeight = AppBar().preferredSize.height;

      return Scaffold(
          backgroundColor: Get.isDarkMode
              ? Color.fromRGBO(19, 20, 21, 1)
              : Color.fromRGBO(243, 243, 240, 1),
          appBar: PreferredSize(
              preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
              child: AppBarCustom(
                title: "Checkout".tr,
                hasBack: true,
                onBack: () {
                  controller.proccess.value = 0;
                  controller.orderSent.value = false;
                },
              )),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: 1.sw - 30,
                  margin: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Get.isDarkMode
                          ? Color.fromRGBO(37, 48, 63, 1)
                          : Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 15, bottom: 20),
                        child: RichText(
                            text: TextSpan(
                                text: "${"Complate your order".tr} — ",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    letterSpacing: -0.4,
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1)),
                                children: <TextSpan>[
                              TextSpan(
                                  text:
                                      "${controller.proccessPercentage.value}%",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                      letterSpacing: -0.4,
                                      color: Get.isDarkMode
                                          ? Color.fromRGBO(255, 255, 255, 1)
                                          : Color.fromRGBO(0, 0, 0, 1)))
                            ])),
                      ),
                      Container(
                        width: 1.sw - 30,
                        margin: EdgeInsets.only(bottom: 15),
                        height: 60,
                        child: Stack(
                          children: [
                            Container(
                              width: 1.sw - 90,
                              height: 18,
                              margin: EdgeInsets.only(left: 30, top: 9),
                              decoration: BoxDecoration(
                                  color: controller.proccess.value == 2
                                      ? Color.fromRGBO(69, 165, 36, 1)
                                      : Get.isDarkMode
                                          ? Color.fromRGBO(26, 34, 44, 1)
                                          : Color.fromRGBO(241, 241, 236, 1)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    width: 24,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 0,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 0,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 0,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 0,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 0,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 0,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 1,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 1,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 1,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 1,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 1,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  CheckoutDot(
                                    isFilled: controller.proccess.value >= 1,
                                    isLast: controller.proccess.value == 2,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                left: 10,
                                top: 0,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                          color: controller.proccess.value == 2
                                              ? Color.fromRGBO(69, 165, 36, 1)
                                              : controller.proccess.value >= 0
                                                  ? Color.fromRGBO(
                                                      255, 184, 0, 1)
                                                  : Get.isDarkMode
                                                      ? Color.fromRGBO(
                                                          26, 34, 44, 1)
                                                      : Color.fromRGBO(
                                                          241, 241, 236, 1),
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      child: Icon(
                                        const IconData(0xef09,
                                            fontFamily: 'MIcon'),
                                        size: 20.sp,
                                        color: controller.proccess.value >= 0
                                            ? Colors.white
                                            : Get.isDarkMode
                                                ? Color.fromRGBO(
                                                    130, 139, 150, 1)
                                                : Color.fromRGBO(
                                                    173, 173, 149, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "Shipping".tr,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                          letterSpacing: -0.4,
                                          color: Get.isDarkMode
                                              ? Color.fromRGBO(255, 255, 255, 1)
                                              : Color.fromRGBO(0, 0, 0, 1)),
                                    ),
                                  ],
                                )),
                            Positioned(
                                left: 0.5.sw - 40,
                                top: 0,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                          color: controller.proccess.value == 2
                                              ? Color.fromRGBO(69, 165, 36, 1)
                                              : controller.proccess.value >= 1
                                                  ? Color.fromRGBO(
                                                      255, 184, 0, 1)
                                                  : Get.isDarkMode
                                                      ? Color.fromRGBO(
                                                          26, 34, 44, 1)
                                                      : Color.fromRGBO(
                                                          241, 241, 236, 1),
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      child: Icon(
                                        const IconData(0xf2ab,
                                            fontFamily: 'MIcon'),
                                        size: 20.sp,
                                        color: controller.proccess.value >= 1
                                            ? Colors.white
                                            : Get.isDarkMode
                                                ? Color.fromRGBO(
                                                    130, 139, 150, 1)
                                                : Color.fromRGBO(
                                                    173, 173, 149, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "Payment".tr,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                          letterSpacing: -0.4,
                                          color: Get.isDarkMode
                                              ? Color.fromRGBO(255, 255, 255, 1)
                                              : Color.fromRGBO(0, 0, 0, 1)),
                                    ),
                                  ],
                                )),
                            Positioned(
                                right: 10,
                                top: 0,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                          color: controller.proccess.value == 2
                                              ? Color.fromRGBO(69, 165, 36, 1)
                                              : Get.isDarkMode
                                                  ? Color.fromRGBO(
                                                      26, 34, 44, 1)
                                                  : Color.fromRGBO(
                                                      241, 241, 236, 1),
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      child: Icon(
                                        const IconData(0xf0ff,
                                            fontFamily: 'MIcon'),
                                        size: 20.sp,
                                        color: controller.proccess.value >= 2
                                            ? Colors.white
                                            : Get.isDarkMode
                                                ? Color.fromRGBO(
                                                    130, 139, 150, 1)
                                                : Color.fromRGBO(
                                                    173, 173, 149, 1),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      "Verify".tr,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp,
                                          letterSpacing: -0.4,
                                          color: Get.isDarkMode
                                              ? Color.fromRGBO(255, 255, 255, 1)
                                              : Color.fromRGBO(0, 0, 0, 1)),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                if (controller.proccess.value == 0)
                  Container(
                    width: 1.sw,
                    constraints: BoxConstraints(minHeight: 1.sh),
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Color.fromRGBO(37, 48, 63, 1)
                            : Colors.white),
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CheckoutHead(text: "Delivery type".tr),
                        Container(
                          margin: EdgeInsets.only(top: 15, bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                child: CheckoutButton(
                                  isActive: controller.deliveryType.value == 1,
                                  title: "Delivery".tr,
                                  icon: controller.deliveryType.value == 1
                                      ? const IconData(0xf1e1,
                                          fontFamily: 'MIcon')
                                      : const IconData(0xf1e2,
                                          fontFamily: 'MIcon'),
                                ),
                                onTap: () {
                                  controller.deliveryType.value = 1;
                                },
                              ),
                              InkWell(
                                child: CheckoutButton(
                                  isActive: controller.deliveryType.value == 2,
                                  title: "Pickup".tr,
                                  icon: controller.deliveryType.value == 2
                                      ? const IconData(0xf115,
                                          fontFamily: 'MIcon')
                                      : const IconData(0xf116,
                                          fontFamily: 'MIcon'),
                                ),
                                onTap: () {
                                  controller.deliveryType.value = 2;
                                },
                              ),
                            ],
                          ),
                        ),
                        CheckoutTextfield(
                          text: "Default address".tr,
                          value: "${address.address}",
                          hasButton: true,
                          onTap: () {
                            Get.toNamed("/locationList");
                          },
                        ),
                        CheckoutTextfield(
                          text: "Full name".tr,
                          value: "${user!.name}",
                          hasButton: false,
                          onTap: () {
                            Get.toNamed("/profileSettings");
                          },
                        ),
                        CheckoutTextfield(
                          text: "Phone number".tr,
                          value: "${user.phone}",
                          hasButton: false,
                          onTap: () {
                            Get.toNamed("/profileSettings");
                          },
                        ),
                      ],
                    ),
                  ),
                if (controller.proccess.value == 1)
                  Container(
                    width: 1.sw,
                    constraints: BoxConstraints(minHeight: 1.sh),
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Color.fromRGBO(37, 48, 63, 1)
                            : Colors.white),
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CheckoutHead(text: "Payment method".tr),
                        Column(
                          children: controller.cards.map((item) {
                            return InkWell(
                              onTap: () {
                                controller.activeCardNumber.value =
                                    item.cardNumber!;
                              },
                              child: CardItem(
                                isActive: controller.activeCardNumber.value ==
                                    item.cardNumber,
                                cardNumber: item.cardNumber,
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) {
                                return DraggableScrollableSheet(
                                  expand: false,
                                  builder: (_, controller) {
                                    return AddCard(
                                      scrollController: controller,
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                const IconData(0xea10, fontFamily: 'MIcon'),
                                color: Color.fromRGBO(69, 165, 36, 1),
                                size: 28.sp,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Add new card".tr,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    letterSpacing: -0.4,
                                    color: Color.fromRGBO(69, 165, 36, 1)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                if (controller.proccess.value == 2)
                  Container(
                    width: 1.sw - 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Get.isDarkMode
                            ? Color.fromRGBO(37, 48, 63, 1)
                            : Color.fromRGBO(255, 255, 255, 1)),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              const IconData(0xeb24, fontFamily: 'MIcon'),
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1),
                              size: 20.sp,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Delivery date".tr,
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      letterSpacing: -0.4,
                                      color: Color.fromRGBO(136, 136, 126, 1)),
                                ),
                                Text(
                                  "${controller.shopController.deliveryDateString}, \n${controller.shopController.deliveryTimeString}",
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                      height: 1.4,
                                      letterSpacing: -0.4,
                                      color: Get.isDarkMode
                                          ? Color.fromRGBO(255, 255, 255, 1)
                                          : Color.fromRGBO(0, 0, 0, 1)),
                                )
                              ],
                            )
                          ],
                        ),
                        InkWell(
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color.fromRGBO(0, 0, 0, 1)),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            alignment: Alignment.center,
                            child: Text(
                              "Change".tr,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  letterSpacing: -0.4,
                                  color: Color.fromRGBO(255, 255, 255, 1)),
                            ),
                          ),
                          onTap: () {
                            Get.toNamed("/shopInfo",
                                arguments: {"tab_index": 1});
                          },
                        )
                      ],
                    ),
                  ),
                if (controller.proccess.value == 2)
                  Container(
                    width: 1.sw,
                    constraints: BoxConstraints(minHeight: 1.sh),
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Color.fromRGBO(37, 48, 63, 1)
                            : Colors.white),
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CheckoutTextfield(
                          text: "Comment".tr,
                          value: controller.orderComment.value,
                          enabled: true,
                          onChange: (text) {
                            controller.orderComment.value = text;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Your order".tr,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(136, 136, 126, 1)),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          color: Get.isDarkMode
                              ? Color.fromRGBO(37, 48, 63, 1)
                              : Colors.white,
                          child: Column(
                            children: <Widget>[
                              Column(
                                children:
                                    controller.cartProducts.map((element) {
                                  return CartSummaryItem(
                                    product: element,
                                  );
                                }).toList(),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Divider(
                                      color: Get.isDarkMode
                                          ? Color.fromRGBO(255, 255, 255, 1)
                                          : Color.fromRGBO(
                                              0,
                                              0,
                                              0,
                                              0.04,
                                            )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 1.0,
                                    dashLength: 4.0,
                                    dashColor: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Colors.black,
                                    dashRadius: 0.0,
                                    dashGapLength: 4.0,
                                    dashGapColor: Colors.transparent,
                                    dashGapRadius: 0.0,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Total product price".tr,
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp,
                                            letterSpacing: -0.3,
                                            color: Get.isDarkMode
                                                ? Color.fromRGBO(
                                                    255, 255, 255, 1)
                                                : Color.fromRGBO(0, 0, 0, 1)),
                                      ),
                                      Text(
                                        "${controller.calculateAmount().toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.sp,
                                            height: 1.9,
                                            letterSpacing: -0.4,
                                            color: Get.isDarkMode
                                                ? Color.fromRGBO(
                                                    255, 255, 255, 1)
                                                : Color.fromRGBO(0, 0, 0, 1)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 1.0,
                                    dashLength: 4.0,
                                    dashColor: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Colors.black,
                                    dashRadius: 0.0,
                                    dashGapLength: 4.0,
                                    dashGapColor: Colors.transparent,
                                    dashGapRadius: 0.0,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Discount".tr,
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp,
                                            letterSpacing: -0.3,
                                            color: Get.isDarkMode
                                                ? Color.fromRGBO(
                                                    255, 255, 255, 1)
                                                : Color.fromRGBO(0, 0, 0, 1)),
                                      ),
                                      Text(
                                        "- ${controller.calculateDiscount()}",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.sp,
                                            height: 1.9,
                                            letterSpacing: -0.4,
                                            color: Get.isDarkMode
                                                ? Color.fromRGBO(
                                                    255, 255, 255, 1)
                                                : Color.fromRGBO(0, 0, 0, 1)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (controller.deliveryType.value == 1)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Delivery".tr,
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.sp,
                                              letterSpacing: -0.3,
                                              color: Get.isDarkMode
                                                  ? Color.fromRGBO(
                                                      255, 255, 255, 1)
                                                  : Color.fromRGBO(0, 0, 0, 1)),
                                        ),
                                        Text(
                                          "${controller.shop!.deliveryFee}",
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16.sp,
                                              height: 1.9,
                                              letterSpacing: -0.4,
                                              color: Get.isDarkMode
                                                  ? Color.fromRGBO(
                                                      255, 255, 255, 1)
                                                  : Color.fromRGBO(0, 0, 0, 1)),
                                        ),
                                      ],
                                    ),
                                  if (controller.deliveryType.value == 1)
                                    SizedBox(
                                      height: 30,
                                    ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Total amount".tr,
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.sp,
                                            letterSpacing: -0.3,
                                            color: Get.isDarkMode
                                                ? Color.fromRGBO(
                                                    255, 255, 255, 1)
                                                : Color.fromRGBO(0, 0, 0, 1)),
                                      ),
                                      Text(
                                        "${(controller.calculateAmount() - controller.calculateDiscount() + (controller.deliveryType.value == 1 ? controller.shop!.deliveryFee! : 0)).toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                            fontSize: 24.sp,
                                            letterSpacing: -0.4,
                                            color: Get.isDarkMode
                                                ? Color.fromRGBO(
                                                    255, 255, 255, 1)
                                                : Color.fromRGBO(0, 0, 0, 1)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 35,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
          extendBody: true,
          bottomNavigationBar: Container(
              height: 100,
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
                  height: 100,
                  width: 1.sw,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(),
                  child: Row(
                    mainAxisAlignment: controller.proccess.value == 2
                        ? MainAxisAlignment.spaceBetween
                        : controller.proccess.value == 0
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (controller.proccess.value == 0)
                        CheckoutBottomButton(
                          title: "Continue".tr,
                          backgroundColor: Color.fromRGBO(0, 0, 0, 1),
                          isActive: controller.proccessPercentage.value >= 46,
                          onTap: () {
                            if (controller.proccessPercentage.value >= 46)
                              controller.proccess.value = 1;
                          },
                        ),
                      if (controller.proccess.value == 1)
                        CheckoutBottomButton(
                          title: "Cash on delivery".tr,
                          backgroundColor: Color.fromRGBO(69, 165, 36, 1),
                          onTap: () {
                            controller.proccess.value = 2;
                            controller.paymentType.value = 1;
                          },
                        ),
                      if (controller.proccess.value == 1)
                        CheckoutBottomButton(
                          title: "Continue".tr,
                          isActive: controller.isCardAvailable.value,
                          backgroundColor: Color.fromRGBO(0, 0, 0, 1),
                          onTap: () {
                            if (controller.isCardAvailable.value)
                              controller.proccess.value = 2;
                          },
                        ),
                      if (controller.proccess.value == 2)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Total amount".tr,
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
                              "${(controller.calculateAmount() - controller.calculateDiscount() + (controller.deliveryType.value == 1 ? controller.shop!.deliveryFee! : 0)).toStringAsFixed(2)}",
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
                      if (controller.proccess.value == 2 &&
                          !controller.orderSent.value)
                        CheckoutBottomButton(
                          title: "Confirm & Pay".tr,
                          backgroundColor: controller.shopController
                                      .deliveryDateString.value.length >
                                  0
                              ? Color.fromRGBO(69, 165, 36, 1)
                              : Color.fromRGBO(136, 136, 126, 1),
                          onTap: () {
                            if (controller.shopController.deliveryDateString
                                    .value.length >
                                0) controller.orderSave();
                          },
                        ),
                      if (controller.proccess.value == 2 &&
                          controller.orderSent.value)
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            color: Color.fromRGBO(69, 165, 36, 1),
                          ),
                        ),
                    ],
                  ),
                ),
              ))));
    });
  }
}
