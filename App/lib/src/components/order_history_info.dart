import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/controllers/auth_controller.dart';

class OrderHistoryInfo extends StatefulWidget {
  OrderHistoryInfoState createState() => OrderHistoryInfoState();
}

class OrderHistoryInfoState extends State<OrderHistoryInfo> {
  List<String> months = [
    "January".tr,
    "February".tr,
    "March".tr,
    "April".tr,
    "May".tr,
    "June".tr,
    "July".tr,
    "August".tr,
    "September".tr,
    "October".tr,
    "November".tr,
    "December".tr
  ];
  AuthController controller = Get.put(AuthController());
  Timer? timer;
  int startTime = 0;
  String date = "";

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    int hour = now.hour;
    String hourString = "$hour";
    if (hour < 10) hourString = "0$hour";
    int minute = now.minute;
    String minuteString = "$minute";
    if (hour < 10) hourString = "0$hour";
    setState(() {
      date = "${months[now.month]} ${now.day}, $hourString:$minuteString";
    });

    startTimer();
  }

  @override
  void dispose() {
    super.dispose();

    timer!.cancel();
    timer = null;
  }

  void startTimer() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    } else {
      timer = new Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          DateTime now = DateTime.now();
          int hour = now.hour;
          String hourString = "$hour";
          if (hour < 10) hourString = "0$hour";
          int minute = now.minute;
          String minuteString = "$minute";
          if (hour < 10) hourString = "0$hour";
          setState(() {
            date = "${months[now.month]} ${now.day}, $hourString:$minuteString";
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.09))),
      child: Row(
        children: <Widget>[
          Text(
            "${"ID".tr} ${controller.user.value!.id}",
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                letterSpacing: -0.4,
                color: Color.fromRGBO(136, 136, 126, 1)),
          ),
          SizedBox(
            width: 10,
          ),
          VerticalDivider(
            color: Color.fromRGBO(221, 221, 218, 1),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "$date",
            style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                letterSpacing: -0.4,
                color: Color.fromRGBO(136, 136, 126, 1)),
          ),
        ],
      ),
    );
  }
}
