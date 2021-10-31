import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/card_textfield.dart';
import 'package:githubit/src/controllers/cart_controller.dart';

class AddCard extends GetView<CartController> {
  final ScrollController? scrollController;

  AddCard({this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Color.fromRGBO(37, 48, 63, 1)
                    : Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 0.1.sw,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(204, 204, 204, 1),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  Container(
                    height: 0.5.sw,
                    width: 1.sw - 30,
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(249, 249, 246, 1),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(Get.isDarkMode
                              ? "lib/assets/images/dark_mode/card.png"
                              : "lib/assets/images/light_mode/card.png"),
                        )),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 30, top: 30),
                    child: Text(
                      controller.cardNumber.value,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 30.sp,
                          color: Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CardTextField(
                    text: "Card number".tr,
                    value: controller.cardNumber.value,
                    type: TextInputType.number,
                    onChange: (text) {
                      controller.cardNumber.value = text;
                      controller.cardNumber.refresh();
                    },
                  ),
                  CardTextField(
                    text: "Name".tr,
                    value: controller.cardName.value,
                    onChange: (text) {
                      controller.cardName.value = text;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: 0.25.sw,
                        child: CardTextField(
                          text: "Expiry date".tr,
                          type: TextInputType.number,
                          value: controller.cardExpiredDate.value,
                          onChange: (text) {
                            controller.cardExpiredDate.value = text;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 0.25.sw,
                        child: CardTextField(
                          text: "CVC".tr,
                          type: TextInputType.number,
                          value: controller.cvc.value,
                          onChange: (text) {
                            if (controller.cvc.value.length < 3)
                              controller.cvc.value = text;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      if (controller.cardExpiredDate.value.length == 4 &&
                          controller.cardNumber.value.length == 16 &&
                          controller.cardName.value.length > 0 &&
                          controller.cvc.value.length == 3)
                        controller.addToCard();
                    },
                    child: Container(
                      width: 1.sw - 30,
                      height: 60,
                      decoration: BoxDecoration(
                          color: controller.cardExpiredDate.value.length == 4 &&
                                  controller.cardNumber.value.length == 16 &&
                                  controller.cardName.value.length > 0 &&
                                  controller.cvc.value.length == 3
                              ? Color.fromRGBO(69, 165, 36, 1)
                              : Color.fromRGBO(136, 136, 126, 1),
                          borderRadius: BorderRadius.circular(30)),
                      alignment: Alignment.center,
                      child: Text(
                        "Add card".tr,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: Color.fromRGBO(255, 255, 255, 1)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  )
                ]),
          ));
    });
  }
}
