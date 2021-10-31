import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/home_tab_button.dart';
import 'package:githubit/src/controllers/auth_controller.dart';
import 'package:githubit/src/models/user.dart';
import 'package:githubit/src/pages/categories.dart';
import 'package:githubit/src/pages/home.dart';
import 'package:githubit/src/pages/savings.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());
  TabController? _tabController;
  User? user;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(length: 4, vsync: this);
  }

  Widget buildPage() {
    if (tabIndex == 0)
      return Home();
    else if (tabIndex == 1)
      return Categories();
    else
      return Savings();
  }

  @override
  Widget build(BuildContext context) {
    user = authController.user.value;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      body: buildPage(),
      extendBody: true,
      bottomNavigationBar: Container(
          height: 80,
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
                height: 80,
                width: 1.sw,
                padding:
                    EdgeInsets.only(top: 18, bottom: 20, left: 28, right: 33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 0.66.sw,
                      height: 60,
                      child: TabBar(
                          indicatorColor: Colors.transparent,
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelPadding: EdgeInsets.all(0),
                          onTap: (index) {},
                          tabs: [
                            Tab(
                              child: HomeTabButton(
                                title: "Home".tr,
                                icon: tabIndex == 0
                                    ? const IconData(0xee26,
                                        fontFamily: 'MIcon')
                                    : const IconData(0xee2b,
                                        fontFamily: 'MIcon'),
                                isActive: tabIndex == 0,
                                onTap: () {
                                  setState(() {
                                    tabIndex = 0;
                                  });
                                },
                              ),
                            ),
                            Tab(
                              child: HomeTabButton(
                                title: "Category".tr,
                                icon: tabIndex == 1
                                    ? const IconData(0xed9d,
                                        fontFamily: 'MIcon')
                                    : const IconData(0xed9e,
                                        fontFamily: 'MIcon'),
                                isActive: tabIndex == 1,
                                onTap: () {
                                  setState(() {
                                    tabIndex = 1;
                                  });
                                },
                              ),
                            ),
                            Tab(
                              child: HomeTabButton(
                                title: "Saved".tr,
                                icon: tabIndex == 2
                                    ? const IconData(0xee0e,
                                        fontFamily: 'MIcon')
                                    : const IconData(0xee0f,
                                        fontFamily: 'MIcon'),
                                isActive: tabIndex == 2,
                                onTap: () {
                                  setState(() {
                                    tabIndex = 2;
                                  });
                                },
                              ),
                            ),
                            Tab(
                              child: HomeTabButton(
                                title: "Cart".tr,
                                icon: tabIndex == 3
                                    ? const IconData(0xf115,
                                        fontFamily: 'MIcon')
                                    : const IconData(0xf116,
                                        fontFamily: 'MIcon'),
                                isActive: tabIndex == 3,
                                onTap: () {
                                  Get.toNamed("/cart");
                                },
                              ),
                            )
                          ]),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(130, 139, 150, 0.1)
                                  : Color.fromRGBO(136, 136, 126, 0.1)),
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                          onTap: () {
                            Get.toNamed("/profile");
                          },
                          child: user!.imageUrl!.length > 4
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.fill,
                                    imageUrl:
                                        "$GLOBAL_IMAGE_URL${user!.imageUrl}",
                                    placeholder: (context, url) => Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: Icon(
                                        const IconData(0xee4b,
                                            fontFamily: 'MIcon'),
                                        color: Color.fromRGBO(233, 233, 230, 1),
                                        size: 20.sp,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ))
                              : Icon(
                                  const IconData(0xf25c, fontFamily: 'MIcon'),
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1),
                                  size: 20,
                                )),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
