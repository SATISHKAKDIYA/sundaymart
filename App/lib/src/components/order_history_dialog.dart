import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/order_history_dialog_date_item.dart';
import 'package:githubit/src/components/order_history_dialog_dot.dart';
import 'package:githubit/src/components/order_history_dialog_step.dart';
import 'package:githubit/src/components/order_history_dialog_step_info.dart';
import 'package:githubit/src/components/order_history_product_item.dart';
import 'package:githubit/src/controllers/order_controller.dart';
import 'package:githubit/src/requests/order_cancel_request.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderHistoryDialog extends GetView<OrderController> {
  final Map<String, dynamic>? data;
  const OrderHistoryDialog({@required this.data});

  @override
  Widget build(BuildContext context) {
    int status = data!['order_status'];

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          decoration: BoxDecoration(
            color: Get.isDarkMode
                ? Color.fromRGBO(37, 48, 63, 1)
                : Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (data!['delivery_boy'] != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 60,
                          height: 60,
                          margin: EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 3,
                                  color: Color.fromRGBO(136, 136, 126, 0.1)),
                              borderRadius: BorderRadius.circular(30)),
                          child: data!['delivery_boy']['image_url'].length > 0
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image(
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          "$GLOBAL_IMAGE_URL${data!['delivery_boy']['image_url']}")),
                                )
                              : Icon(
                                  const IconData(0xf25c, fontFamily: 'MIcon'),
                                  color: Colors.black,
                                  size: 20.sp,
                                ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${data!['delivery_boy']['name']} ${data!['delivery_boy']['surname']}",
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  letterSpacing: -0.4,
                                  color: Color.fromRGBO(0, 0, 0, 1)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Delivery boy".tr,
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      letterSpacing: -0.4,
                                      color: Color.fromRGBO(136, 136, 126, 1)),
                                ),
                                // Container(
                                //   width: 4,
                                //   height: 4,
                                //   margin: EdgeInsets.symmetric(horizontal: 12),
                                //   decoration: BoxDecoration(
                                //       color: Color.fromRGBO(196, 196, 196, 1),
                                //       borderRadius: BorderRadius.circular(2)),
                                // ),
                                // Icon(
                                //   const IconData(0xf18e, fontFamily: 'MIcon'),
                                //   size: 16.sp,
                                //   color: Color.fromRGBO(255, 161, 0, 1),
                                // ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                // Text(
                                //   "4.5",
                                //   style: TextStyle(
                                //       fontFamily: 'Inter',
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 12.sp,
                                //       letterSpacing: -0.35,
                                //       color: Color.fromRGBO(0, 0, 0, 1)),
                                // ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        String url = "tel:${data!['delivery_boy']['phone']}";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        height: 48,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromRGBO(243, 243, 240, 1)),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              // const IconData(0xef88, fontFamily: 'MIcon'),
                              const IconData(0xefe9, fontFamily: 'MIcon'),
                              size: 24.sp,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Call".tr,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  letterSpacing: -0.4,
                                  color: Color.fromRGBO(0, 0, 0, 1)),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              Container(
                height: 70,
                width: 1.sw - 30,
                padding: EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.only(top: 40, bottom: 35),
                decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Color.fromRGBO(26, 34, 44, 1)
                        : Color.fromRGBO(0, 0, 0, 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    OrderHistoryDialogDateItem(
                      title: "Date purchased".tr,
                      date: controller.getTime2(data!['created_at']),
                    ),
                    VerticalDivider(
                      color: Color.fromRGBO(255, 255, 255, 0.64),
                    ),
                    OrderHistoryDialogDateItem(
                      title: "Delivery date".tr,
                      date: controller.getTime2(
                          "${data!['delivery_date']} ${data!['time_unit']['name'].substring(9, 17)}"),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 8,
                      ),
                      OrderHistoryDialogStep(
                        icon: const IconData(0xf0ff, fontFamily: 'MIcon'),
                        status: status == 1,
                        passed: status > 1,
                      ),
                      OrderHistoryDialogDot(),
                      OrderHistoryDialogDot(),
                      OrderHistoryDialogDot(),
                      OrderHistoryDialogStep(
                        icon: const IconData(0xf20e, fontFamily: 'MIcon'),
                        status: status == 2,
                        passed: status > 2,
                      ),
                      OrderHistoryDialogDot(),
                      OrderHistoryDialogDot(),
                      OrderHistoryDialogDot(),
                      OrderHistoryDialogStep(
                        icon: const IconData(0xf230, fontFamily: 'MIcon'),
                        status: status == 3,
                        passed: status > 3,
                      ),
                      OrderHistoryDialogDot(),
                      OrderHistoryDialogDot(),
                      OrderHistoryDialogDot(),
                      OrderHistoryDialogStep(
                        icon: const IconData(0xf18e, fontFamily: 'MIcon'),
                        status: status == 4,
                        passed: status > 4,
                      ),
                      SizedBox(
                        height: 8,
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      OrderHistoryDialogStepInfo(
                        status: status == 1,
                        passed: status > 1,
                        title: "Order accepted".tr,
                        time: controller.getOnlyTime(data!['created_at']),
                      ),
                      OrderHistoryDialogStepInfo(
                        status: status == 2,
                        passed: status > 2,
                        title: "Order processing".tr,
                        time: data!['processing_date'] != null
                            ? controller.getOnlyTime(data!['processing_date'])
                            : "",
                      ),
                      OrderHistoryDialogStepInfo(
                        status: status == 3,
                        passed: status > 3,
                        title: "Out for delivery".tr,
                        time: data!['ready_date'] != null
                            ? controller.getOnlyTime(data!['ready_date'])
                            : "",
                      ),
                      OrderHistoryDialogStepInfo(
                        status: status == 4,
                        passed: status > 4,
                        title: "Delivered to customer".tr,
                        time: data!['delivered_date'] != null
                            ? controller.getOnlyTime(data!['delivered_date'])
                            : "",
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 48,
              ),
              Row(
                children: <Widget>[
                  Icon(
                    const IconData(0xef13, fontFamily: 'MIcon'),
                    size: 24.sp,
                    color: Get.isDarkMode
                        ? Color.fromRGBO(130, 139, 150, 1)
                        : Color.fromRGBO(136, 136, 126, 1),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Delivery address".tr,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            letterSpacing: -0.4,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(130, 139, 150, 1)
                                : Color.fromRGBO(136, 136, 126, 1)),
                      ),
                      Container(
                        width: 1.sw - 80,
                        child: Text(
                          "${data!['address']['address']}",
                          softWrap: true,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              height: 1.6,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Divider(
                color: Color.fromRGBO(0, 0, 0, 0.04),
              ),
              SizedBox(
                height: 40,
              ),
              RichText(
                  text: TextSpan(
                      text: "${"Products".tr}  ",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          letterSpacing: -0.5,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1)),
                      children: <TextSpan>[
                    TextSpan(
                        text: "— ${data!['details'].length} ${"items".tr}",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 18.sp,
                            letterSpacing: -0.5,
                            color: Get.isDarkMode
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(0, 0, 0, 1)))
                  ])),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        Container(
          color: Get.isDarkMode ? Color.fromRGBO(37, 48, 63, 1) : Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: data!['details'].map<Widget>((item) {
                    return OrderHistoryProductItem(
                      product: item,
                    );
                  }).toList(),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Divider(
                        color: Get.isDarkMode
                            ? Color.fromRGBO(255, 255, 255, 0.04)
                            : Color.fromRGBO(
                                0,
                                0,
                                0,
                                0.04,
                              )),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 25,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total product price".tr,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              letterSpacing: -0.3,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                        Text(
                          "${double.parse((data!['total_sum'] + data!['total_discount'] - data!['delivery_fee']).toString()).toStringAsFixed(2)}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              height: 1.9,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Discount".tr,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              letterSpacing: -0.3,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                        Text(
                          "- ${double.parse(data!['total_discount'].toString()).toStringAsFixed(2)}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              height: 1.9,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Delivery fee".tr,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              letterSpacing: -0.3,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                        Text(
                          "${data!['delivery_fee']}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 16.sp,
                              height: 1.9,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ],
                    ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Total amount".tr,
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              letterSpacing: -0.3,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                        Text(
                          "${double.parse(data!['total_sum'].toString()).toStringAsFixed(2)}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              fontSize: 24.sp,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    if (status < 4)
                      TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.all(0))),
                        onPressed: () async {
                          await orderCancelRequest(data!['id']);
                          await controller
                              .getOrderCount(int.parse(data!['id_user']));
                          controller.ordersList.value = [];
                          controller.ordersList.refresh();
                          Get.back();
                        },
                        child: Container(
                          height: 60,
                          width: 0.6.sw,
                          padding: EdgeInsets.symmetric(horizontal: 60),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color.fromRGBO(222, 31, 54, 1),
                              ),
                              borderRadius: BorderRadius.circular(30)),
                          alignment: Alignment.center,
                          child: Text(
                            "Cancel order".tr,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Color.fromRGBO(222, 31, 54, 1)),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 45,
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
