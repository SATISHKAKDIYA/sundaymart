import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:githubit/src/components/appbar.dart';
import 'package:githubit/src/components/settings_item.dart';
import 'package:githubit/src/components/sp_checkbox.dart';
import 'package:githubit/src/controllers/settings_controller.dart';
import 'package:share_plus/share_plus.dart';

class Settings extends GetView<SettingsController> {
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
            title: "Setting".tr,
            hasBack: true,
          )),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Obx(() => SettingsItem(
                icon: const IconData(0xebf8, fontFamily: 'MIcon'),
                text: "UI Theme".tr,
                rightWidget: SpCheckBox(
                  onChanged: (value) {
                    controller.setDarkTheme(value);
                  },
                  activeText: "Dark".tr,
                  inactiveText: "Light".tr,
                  value: controller.isDarkTheme.value,
                ))),
            InkWell(
              child: SettingsItem(
                icon: const IconData(0xedcf, fontFamily: 'MIcon'),
                text: "Languages".tr,
                rightWidget: Container(
                  child: Icon(
                    const IconData(0xea6e, fontFamily: 'MIcon'),
                    color: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1),
                    size: 20.sp,
                  ),
                ),
              ),
              onTap: () => Get.toNamed("/language"),
            ),
            InkWell(
              child: SettingsItem(
                icon: const IconData(0xebb2, fontFamily: 'MIcon'),
                text: "Currencies".tr,
                rightWidget: Container(
                  child: Icon(
                    const IconData(0xea6e, fontFamily: 'MIcon'),
                    color: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1),
                    size: 20.sp,
                  ),
                ),
              ),
              onTap: () => Get.toNamed("/currency"),
            ),
            InkWell(
              child: SettingsItem(
                icon: const IconData(0xef12, fontFamily: 'MIcon'),
                text: "Saved location".tr,
              ),
              onTap: () => Get.toNamed("/locationList"),
            ),
            InkWell(
              child: SettingsItem(
                icon: const IconData(0xf0fe, fontFamily: 'MIcon'),
                text: "Share friends".tr,
              ),
              onTap: () => Share.share(
                  '${"check out our website".tr} https://admin.githubit.com'),
            )
          ],
        ),
      ),
    );
  }
}
