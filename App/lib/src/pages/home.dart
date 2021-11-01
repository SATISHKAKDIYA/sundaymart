import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/banners.dart';
import 'package:githubit/src/components/home_category.dart';
import 'package:githubit/src/components/home_brands.dart';
import 'package:githubit/src/components/home_silver_bar.dart';
import 'package:githubit/src/components/home_tabs.dart';
import 'package:githubit/src/controllers/auth_controller.dart';
import 'package:githubit/src/controllers/notification_controller.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  int tabIndex = 2;

  @override
  void initState() {
    super.initState();
    notificationController.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.isDarkMode
            ? Color.fromRGBO(19, 20, 21, 1)
            : Color.fromRGBO(243, 243, 240, 1),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[HomeSilverBar()];
          },
          body: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 100),
              child: Column(
                children: <Widget>[
                  Banners(),
                  HomeTabs(),
                  HomeCategory(),
                  HomeBrands()
                ],
              )),
        ));
  }
}
