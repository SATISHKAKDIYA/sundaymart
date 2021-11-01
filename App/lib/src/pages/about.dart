import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/empty.dart';
import 'package:githubit/src/controllers/about_controller.dart';
import 'package:share_plus/share_plus.dart';

class About extends GetView<AboutControler> {
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
          child: AppBarCustom(
            title: "About".tr,
            hasBack: true,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (controller.shopController.defaultShop.value != null &&
                controller.shopController.defaultShop.value!.id != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: FutureBuilder<String>(
                  future: controller.getAboutContent(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Html(data: snapshot.data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Container();
                  },
                ),
              ),
            if (controller.shopController.defaultShop.value == null ||
                controller.shopController.defaultShop.value!.id == null)
              Empty(message: "To see about, please, select shop")
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
          height: 60,
          width: 1.sw - 30,
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Get.isDarkMode
                  ? Color.fromRGBO(37, 48, 63, 1)
                  : Color.fromRGBO(255, 255, 255, 1),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  spreadRadius: 0,
                  color: Get.isDarkMode
                      ? Color.fromRGBO(23, 27, 32, 0.13)
                      : Color.fromRGBO(169, 169, 150, 0.13),
                )
              ]),
          child: TextButton(
            onPressed: () => Share.share(
                '${"check out our website".tr} https://admin.githubit.com'),
            style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(10))),
            child: Row(
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  child: Icon(
                    const IconData(0xf0fe, fontFamily: 'MIcon'),
                    color: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
                Text(
                  "Share friends".tr,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    letterSpacing: -0.5,
                    color: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
