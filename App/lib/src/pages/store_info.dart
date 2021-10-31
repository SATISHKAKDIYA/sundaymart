import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/config/global_config.dart';
import 'package:githubit/src/components/delivery_time_item.dart';
import 'package:githubit/src/controllers/shop_controller.dart';
import 'package:githubit/src/models/shop.dart';

class StoreInfo extends StatefulWidget {
  @override
  StoreInfoState createState() => StoreInfoState();
}

class StoreInfoState extends State<StoreInfo>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final ShopController shopController = Get.put(ShopController());
  int tabIndex = 1;

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

  @override
  void initState() {
    super.initState();

    int index = Get.arguments["tab_index"];

    setState(() {
      tabIndex = index;
    });

    _tabController =
        new TabController(length: 2, vsync: this, initialIndex: index);
  }

  @override
  Widget build(BuildContext context) {
    Shop? shop = shopController.defaultShop.value;
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
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Get.isDarkMode
                        ? Color.fromRGBO(23, 27, 32, 0.13)
                        : Color.fromRGBO(169, 169, 150, 0.13))
              ],
              color: Get.isDarkMode
                  ? Color.fromRGBO(37, 48, 63, 1)
                  : Colors.white),
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
                      margin: EdgeInsets.only(right: 8),
                      child: Icon(
                        const IconData(0xea64, fontFamily: 'MIcon'),
                        size: 24.sp,
                        color: Get.isDarkMode
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                    onTap: () => Get.back(),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image(
                        width: 26,
                        height: 26,
                        image:
                            NetworkImage("$GLOBAL_IMAGE_URL${shop!.logoUrl}")),
                  ),
                  Container(
                    height: 34,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "${shop.name}",
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          letterSpacing: -0.4,
                          color: Get.isDarkMode
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 1.sw,
              height: 60,
              decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Color.fromRGBO(26, 34, 44, 1)
                      : Color.fromRGBO(249, 249, 246, 1)),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Color.fromRGBO(69, 165, 36, 1),
                indicatorWeight: 2,
                labelColor: Get.isDarkMode
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(0, 0, 0, 1),
                unselectedLabelColor: Get.isDarkMode
                    ? Color.fromRGBO(130, 139, 150, 1)
                    : Color.fromRGBO(136, 136, 126, 1),
                onTap: (index) {
                  setState(() {
                    tabIndex = index;
                  });
                },
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  letterSpacing: -0.4,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  letterSpacing: -0.4,
                ),
                tabs: [
                  Tab(
                    child: Text("Market info".tr),
                  ),
                  Tab(
                    child: Text("Delivery times".tr),
                  )
                ],
              ),
            ),
            Container(
              child: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Address".tr,
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
                        width: 1.sw - 30,
                        margin: EdgeInsets.only(top: 8, bottom: 40),
                        child: Text(
                          "${shop.address}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                      Text(
                        "Working hours".tr,
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
                        width: 1.sw - 30,
                        margin: EdgeInsets.only(top: 8, bottom: 40),
                        child: Text(
                          "${shop.openHours} - ${shop.closeHours}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                      Text(
                        "Delivery fee".tr,
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
                        width: 1.sw - 30,
                        margin: EdgeInsets.only(top: 8, bottom: 40),
                        child: Text(
                          "${shop.deliveryFee}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                      Text(
                        "Delivery type".tr,
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
                        width: 1.sw - 30,
                        margin: EdgeInsets.only(top: 8, bottom: 40),
                        child: Text(
                          "${"Delivery".tr} — ${shop.deliveryType == 3 ? "Delivery & Pickup".tr : shop.deliveryType == 1 ? "Delivery".tr : "Pickup".tr}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                      Divider(
                        color: Get.isDarkMode
                            ? Color.fromRGBO(130, 139, 150, 0.2)
                            : Color.fromRGBO(136, 136, 136, 0.2),
                        height: 1,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Descreption".tr,
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
                        width: 1.sw - 30,
                        margin: EdgeInsets.only(top: 8, bottom: 40),
                        child: Text(
                          "${shop.description}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              height: 1.6,
                              letterSpacing: -0.4,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                      Text(
                        "Info".tr,
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
                        width: 1.sw - 30,
                        margin: EdgeInsets.only(top: 8, bottom: 40),
                        child: Text(
                          "${shop.info}",
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              letterSpacing: -0.4,
                              height: 1.6,
                              color: Get.isDarkMode
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(0, 0, 0, 1)),
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  String deliveryDate = shopController.deliveryDate.value;
                  int deliveryTime = shopController.deliveryTime.value;

                  return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                      child: Column(
                        children: <Widget>[
                          for (int i = 0; i < 5; i++)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  shopController.shopTimeUnitsList.map((item) {
                                DateTime now = DateTime.now();
                                DateTime date =
                                    DateTime(now.year, now.month, now.day + i);

                                String month = "${date.month}";
                                if (date.month < 10) month = "0${date.month}";

                                String day = "${date.day}";
                                if (date.day < 10) day = "0${date.day}";

                                String dayString = "${date.year}-$month-$day";

                                return InkWell(
                                  child: DeliveryTimeItem(
                                    date:
                                        "${date.day} ${months[date.month - 1]}, ",
                                    date2: i == 0
                                        ? "Today".tr
                                        : i == 1
                                            ? "Tomorrow".tr
                                            : "",
                                    time: item.name,
                                    color: i == 0
                                        ? Color.fromRGBO(69, 165, 36, 1)
                                        : i == 1
                                            ? Color.fromRGBO(255, 184, 0, 1)
                                            : Get.isDarkMode
                                                ? Color.fromRGBO(
                                                    130, 139, 150, 1)
                                                : Color.fromRGBO(
                                                    136, 136, 126, 1),
                                    isSelected: deliveryDate == dayString &&
                                        deliveryTime == item.id,
                                  ),
                                  onTap: () {
                                    shopController.deliveryDate.value =
                                        dayString;
                                    shopController.deliveryTime.value =
                                        item.id!;

                                    shopController.deliveryDateString.value =
                                        "${date.day} ${months[date.month - 1]}";
                                    shopController.deliveryTimeString.value =
                                        item.name!;

                                    shopController.deliveryTime.refresh();
                                    shopController.deliveryTime.refresh();
                                    shopController.deliveryDateString.refresh();
                                    shopController.deliveryTimeString.refresh();
                                  },
                                );
                              }).toList(),
                            ),
                        ],
                      ));
                })
              ][tabIndex],
            )
          ],
        ),
      ),
    );
  }
}
