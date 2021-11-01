import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderHistoryItem extends StatelessWidget {
  final String? shopName;
  final int? orderId;
  final String? orderDate;
  final double? amount;
  final int? status;
  final Function()? onTapBtn;
  const OrderHistoryItem(
      {this.shopName,
      this.amount,
      this.orderDate,
      this.orderId,
      this.status,
      this.onTapBtn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw - 30,
      height: 160,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
                color: Get.isDarkMode
                    ? Color.fromRGBO(23, 27, 32, 1)
                    : Color.fromRGBO(169, 169, 150, 0.13))
          ],
          color: Get.isDarkMode
              ? Color.fromRGBO(37, 48, 63, 1)
              : Color.fromRGBO(255, 255, 255, 1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Shop".tr,
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
                    "$shopName",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        letterSpacing: -0.5,
                        height: 1.9,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(0, 0, 0, 1)),
                  )
                ],
              ),
              status == 1
                  ? InkWell(
                      child: Container(
                          height: 30,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromRGBO(255, 184, 0, 1)),
                          child: Text(
                            "Open".tr,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                letterSpacing: -0.5,
                                color: !Get.isDarkMode
                                    ? Color.fromRGBO(255, 255, 255, 1)
                                    : Color.fromRGBO(0, 0, 0, 1)),
                          )),
                      onTap: onTapBtn,
                    )
                  : Container(
                      height: 30,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: status == 4
                              ? Color.fromRGBO(69, 165, 36, 1)
                              : Color.fromRGBO(222, 31, 54, 1)),
                      child: RichText(
                          text: TextSpan(
                              text: "${"Order".tr} ",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  letterSpacing: -0.5,
                                  color: !Get.isDarkMode
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1)),
                              children: <TextSpan>[
                            TextSpan(
                                text: "— #$orderId",
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.sp,
                                    letterSpacing: -0.5,
                                    color: !Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1)))
                          ])),
                    ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Date".tr,
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
                    "$orderDate",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        letterSpacing: -0.5,
                        height: 1.9,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(0, 0, 0, 1)),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Order amount".tr,
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
                    "$amount",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        letterSpacing: -0.5,
                        height: 1.9,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(0, 0, 0, 1)),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
