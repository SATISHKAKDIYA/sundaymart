import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/message_get.dart';
import 'package:githubit/src/components/message_sent.dart';
import 'package:githubit/src/controllers/chat_controller.dart';

class Chat extends GetView<ChatController> {
  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      appBar: PreferredSize(
        preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
        child: Container(
          width: 1.sw,
          height: statusBarHeight + appBarHeight,
          decoration: BoxDecoration(boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 2,
                spreadRadius: 0,
                color: Color.fromRGBO(169, 169, 150, 0.13))
          ], color: Colors.white),
          padding: EdgeInsets.only(left: 15, right: 15, top: statusBarHeight),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: 34,
                      height: 34,
                      child: Icon(
                        const IconData(0xea64, fontFamily: 'MIcon'),
                        size: 24.sp,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                    onTap: () => Get.back(),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 3,
                            color: Color.fromRGBO(136, 136, 126, 0.1)),
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      const IconData(0xf25c, fontFamily: 'MIcon'),
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${controller.user.value!.name}",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            letterSpacing: -1,
                            color: Color.fromRGBO(0, 0, 0, 1)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            controller.user.value!.role == 1
                                ? "Manager".tr
                                : controller.user.value!.role == 2
                                    ? "Manager".tr
                                    : "Driver".tr,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                                letterSpacing: -0.5,
                                color: Color.fromRGBO(136, 136, 126, 1)),
                          ),
                          Container(
                            width: 4,
                            height: 4,
                            margin: EdgeInsets.only(left: 12, right: 4),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(69, 165, 36, 1),
                                borderRadius: BorderRadius.circular(2)),
                          ),
                          Text(
                            "Online".tr,
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                fontSize: 10.sp,
                                letterSpacing: -0.5,
                                color: Color.fromRGBO(69, 165, 36, 1)),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[MessageSent(), MessageGet(), MessageGet()],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        width: 1.sw,
        height: 77,
        padding: EdgeInsets.symmetric(horizontal: 35),
        decoration: BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              spreadRadius: 0,
              color: Color.fromRGBO(169, 169, 150, 0.13))
        ], color: Color.fromRGBO(255, 255, 255, 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 1.sw - 110,
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        letterSpacing: -0.5,
                        color: Color.fromRGBO(136, 136, 126, 1)),
                    hintText: "${"Type  something".tr}..."),
              ),
            ),
            InkWell(
              onTap: () {
                controller.connect();
              },
              child: Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(69, 165, 36, 1),
                    borderRadius: BorderRadius.circular(37)),
                child: Icon(
                  const IconData(0xf0d7, fontFamily: 'MIcon'),
                  size: 18.sp,
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
