import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/empty.dart';
import 'package:githubit/src/components/order_history_dialog.dart';
import 'package:githubit/src/components/order_history_info.dart';
import 'package:githubit/src/components/order_history_item.dart';
import 'package:githubit/src/components/order_history_tab.dart';
import 'package:githubit/src/components/shadows/order_history_item_shadow.dart';
import 'package:githubit/src/controllers/auth_controller.dart';
import 'package:githubit/src/controllers/language_controller.dart';
import 'package:githubit/src/controllers/order_controller.dart';

class OrderHistory extends StatefulWidget {
  @override
  OrderHistoryState createState() => OrderHistoryState();
}

class OrderHistoryState extends State<OrderHistory>
    with TickerProviderStateMixin {
  TabController? tabController;
  final AuthController authController = Get.put(AuthController());
  final OrderController orderController = Get.put(OrderController());
  final LanguageController languageController = Get.put(LanguageController());
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();

    tabController = new TabController(length: 3, vsync: this);
  }

  void showSheet(item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              child: OrderHistoryDialog(
                data: item,
              ),
              controller: controller,
            );
          },
        );
      },
    );
  }

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
            title: "My orders".tr,
            hasBack: true,
            actions: OrderHistoryInfo(),
          )),
      body: Column(
        children: <Widget>[
          Container(
            width: 1.sw,
            height: 60,
            decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? Color.fromRGBO(26, 34, 44, 1)
                    : Color.fromRGBO(249, 249, 246, 1)),
            child: TabBar(
                controller: tabController,
                indicatorColor: Color.fromRGBO(69, 165, 36, 1),
                indicatorWeight: 2,
                labelColor: Get.isDarkMode
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(0, 0, 0, 1),
                unselectedLabelColor: Get.isDarkMode
                    ? Color.fromRGBO(130, 139, 150, 1)
                    : Color.fromRGBO(136, 136, 126, 1),
                labelStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  letterSpacing: -0.4,
                ),
                onTap: (index) {
                  setState(() {
                    tabIndex = index;
                  });

                  orderController.load.value = true;
                  orderController.ordersList.value = [];
                  orderController.ordersList.refresh();
                },
                tabs: [
                  Tab(
                      child: OrderHistoryTab(
                    name: "Completed".tr,
                    type: 1,
                  )),
                  Tab(
                      child: OrderHistoryTab(
                          name: "Open".tr,
                          type: 2,
                          count: orderController.newOrderCount.value)),
                  Tab(
                      child: OrderHistoryTab(
                    name: "Cancelled".tr,
                    type: 3,
                  )),
                ]),
          ),
          Container(
            child: [
              Container(
                width: 1.sw,
                height: 1.sh - 165,
                child: FutureBuilder<List>(
                    future: orderController.getOrderHistory(
                        authController.user.value!,
                        4,
                        languageController.activeLanguageId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !orderController.load.value) {
                        return orderController.ordersList.length == 0
                            ? Empty(message: "No completed orders".tr)
                            : ListView.builder(
                                itemCount: orderController.ordersList.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                      orderController.ordersList[index];

                                  return OrderHistoryItem(
                                    shopName: data['shop']['language']['name'],
                                    status: 4,
                                    orderId: data['id'],
                                    orderDate: orderController
                                        .getTime(data['created_at']),
                                    amount: data['total_sum'],
                                  );
                                });
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return ListView.builder(
                          itemCount: 4,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          itemBuilder: (context, index) {
                            return OrderHistoryItemShadow();
                          });
                    }),
              ),
              Container(
                width: 1.sw,
                height: 1.sh - 165,
                child: FutureBuilder<List>(
                    future: orderController.getOrderHistory(
                        authController.user.value!,
                        1,
                        languageController.activeLanguageId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !orderController.load.value) {
                        return orderController.ordersList.length == 0
                            ? Empty(message: "No uncompleted orders".tr)
                            : ListView.builder(
                                itemCount: orderController.ordersList.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                      orderController.ordersList[index];
                                  return OrderHistoryItem(
                                    shopName: data['shop']['language']['name'],
                                    status: 1,
                                    onTapBtn: () {
                                      showSheet(data);
                                    },
                                    orderId: data['id'],
                                    orderDate: orderController
                                        .getTime(data['created_at']),
                                    amount: data['total_sum'],
                                  );
                                });
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return ListView.builder(
                          itemCount: 4,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          itemBuilder: (context, index) {
                            return OrderHistoryItemShadow();
                          });
                    }),
              ),
              Container(
                width: 1.sw,
                height: 1.sh - 165,
                child: FutureBuilder<List>(
                    future: orderController.getOrderHistory(
                        authController.user.value!,
                        5,
                        languageController.activeLanguageId.value),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && !orderController.load.value) {
                        return orderController.ordersList.length == 0
                            ? Empty(message: "No canceled orders".tr)
                            : ListView.builder(
                                itemCount: orderController.ordersList.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                      orderController.ordersList[index];

                                  return OrderHistoryItem(
                                    shopName: data['shop']['language']['name'],
                                    orderId: data['id'],
                                    status: 5,
                                    orderDate: orderController
                                        .getTime(data['created_at']),
                                    amount: data['total_sum'],
                                  );
                                });
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return ListView.builder(
                          itemCount: 4,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          itemBuilder: (context, index) {
                            return OrderHistoryItemShadow();
                          });
                    }),
              ),
            ][tabIndex],
          )
        ],
      ),
    );
  }
}
