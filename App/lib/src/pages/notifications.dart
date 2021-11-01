import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/empty.dart';
import 'package:githubit/src/components/notification_item.dart';
import 'package:githubit/src/controllers/notification_controller.dart';

class Notifications extends GetView<NotificationController> {
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
              title: "Notifications".tr,
              hasBack: true,
            )),
        body: SingleChildScrollView(
          child: Container(
            width: 1.sw,
            height: 1.sh - 165,
            child: FutureBuilder<List>(
                future: controller.getNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data!;
                    return data.length == 0
                        ? Empty(message: "No notification found".tr)
                        : ListView.builder(
                            itemCount: data.length,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            itemBuilder: (context, index) {
                              return Obx(() {
                                int ind = controller.readedNotificationIds
                                    .indexWhere((element) =>
                                        element == data[index]['id']);

                                return InkWell(
                                  onTap: () {
                                    if (controller.activeNotificationId.value >
                                            0 &&
                                        controller.activeNotificationId.value ==
                                            data[index]['id'])
                                      controller.activeNotificationId.value = 0;
                                    else {
                                      controller.activeNotificationId.value =
                                          data[index]['id'];
                                      if (ind == -1)
                                        controller.readedNotificationIds
                                            .add(data[index]['id']);
                                    }
                                    controller.getUnreadedNotifications();
                                    controller.activeNotificationId.refresh();
                                  },
                                  child: NotificationItem(
                                      title: data[index]['title'],
                                      isReaded: ind != -1,
                                      isOpen: controller
                                              .activeNotificationId.value ==
                                          data[index]['id'],
                                      date: controller
                                          .getTime(data[index]['send_time']),
                                      description: data[index]['description'],
                                      hasImage: int.parse(data[index]
                                                  ['has_image']
                                              .toString()) ==
                                          1,
                                      imageUrl: data[index]['image_url']),
                                );
                              });
                            });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return Container();
                }),
          ),
        ),
        extendBody: true,
        bottomNavigationBar: InkWell(
          onTap: () {
            DateTime now = DateTime.now();
            int hour = now.hour;
            int minute = now.minute;
            int second = now.second;
            int month = now.month;
            int day = now.day;

            String date =
                "${now.year}-${month < 10 ? '0$month' : month}-${day < 10 ? '0$day' : day} ${hour < 10 ? '0$hour' : hour}:${minute < 10 ? '0$minute' : minute}:${second < 10 ? '0$second' : second}";

            controller.date.value = date;
            controller.readedNotificationIds.value = [];
            controller.activeNotificationId.value = 0;
            controller.date.refresh();
            controller.notificationsList.value = [];
            controller.notificationsList.refresh();
            controller.readedNotificationIds.refresh();
            controller.activeNotificationId.refresh();

            final box = GetStorage();
            box.write('date', date);

            Get.back();
          },
          child: Container(
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 0.29.sw, vertical: 20),
            width: 0.42.sw,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromRGBO(221, 35, 57, 1)),
            alignment: Alignment.center,
            child: Text(
              "Clear all".tr,
              style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  height: 1.45,
                  color: Color.fromRGBO(255, 255, 255, 1)),
            ),
          ),
        ));
  }
}
